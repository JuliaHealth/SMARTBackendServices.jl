function _backend_services_create_jwt(config::BackendServicesConfig, token_endpoint::AbstractString)
    # Random string that uniquely identifies the JWT
    jti = Random.randstring(150)

    # Expiration time (integer) in seconds since "epoch"
    # SHALL be no more than 5 minutes in the future
    expiration_time = Dates.now(Dates.UTC) + Dates.Minute(4)
    expiration_time_seconds_since_epoch_utc = round(Int, Dates.datetime2unix(expiration_time))
    
    jwt_payload_claims_dict = Dict(
        "iss" => config.client_id,
        "sub" => config.client_id,
        "aud" => token_endpoint,
        "jti" => jti,
        "exp" => expiration_time_seconds_since_epoch_utc,
    )
    jwt = JWTs.JWT(; payload = jwt_payload_claims_dict)

    # Sign
    JWTs.sign!(jwt, config.key, config.keyid)
    @assert JWTs.issigned(jwt)
    @assert JWTs.kid(jwt) == config.keyid

    return string(jwt)
end

# Obtain the token endpoint from the well-known URIs
# Ref: https://www.hl7.org/fhir/smart-app-launch/backend-services.html#retrieve-well-knownsmart-configuration
function _token_endpoint_wellknown(config::BackendServicesConfig)
    # Request the SMART configuration file
    _config_response = HTTP.request(
        "GET",
        joinpath(config.base_url, ".well-known/smart-configuration");
        # In principle, it should be possible to omit the header
        # (and servers may ignore it anyway)
        # Ref: https://www.hl7.org/fhir/smart-app-launch/conformance.html#using-well-known
        headers = ("Accept" => "application/json",),
        # Old servers might still only support the /metadata endpoint (even though its use for SMART capabilities is deprecated)
        # Hence we do not throw an exception if the request fails but try the /metadata endpoint first
        # Ref: https://hl7.org/fhir/smart-app-launch/1.0.0/conformance/index.html#declaring-support-for-oauth2-endpoints
        # Ref: https://www.hl7.org/fhir/smart-app-launch/conformance.html#smart-on-fhir-oauth-authorization-endpoints-and-capabilities
        status_exception = false,
    )

    # Exit gracefully (return `nothing`) if the server does not convey its SMART capabilities using well-known URIs
    if _config_response.status != 200
        return nothing
    end

    # Extract the token endpoint from the JSON response
    config_response = JSON3.read(_config_response.body)
    get(config_response, :token_endpoint) do
        error(
            "SMART configuration: Violation of the FHIR specification. The mandatory `token_endpoint` is missing from the Well-Known Uniform Resource Identifiers (URIs) JSON document.",
        )
    end::String
end

# Obtain the token endpoint from the CapabilityStatement at the /metadata endpoint
# Note: Declaring SMART capabilities using the /metadata endpoint is deprecated but old servers might still not support the well-known URIs
# Ref: https://hl7.org/fhir/smart-app-launch/1.0.0/conformance/index.html#declaring-support-for-oauth2-endpoints
function _token_endpoint_metadata(config::BackendServicesConfig)
    # Request the CapabilityStatement
    _metadata_response = HTTP.request(
        "GET",
        joinpath(config.base_url, "metadata");
        # We only support FHIR version R4
        # Ref: https://hl7.org/fhir/R4/versioning.html#mt-version
        headers = ("Accept" => "application/fhir+json; fhirVersion=4.0"),
        # We throw our own, hopefully more descriptive, exception if necessary
        status_exception = false,
    )

    # Exit gracefully (return `nothing`) if the server does not convey its SMART capabilities at the /metadata endpoint
    if _metadata_response.status != 200
        return nothing
    end

    # Extract the token endpoint from the JSON response
    # Ref: https://hl7.org/fhir/smart-app-launch/1.0.0/conformance/index.html#declaring-support-for-oauth2-endpoints
    # Ref: https://hl7.org/fhir/R4/capabilitystatement.html
    compat_statement = JSON3.read(_metadata_response.body)
    rest = get(compat_statement, :rest, nothing)
    if rest !== nothing
        for rest in compat_statement.rest
            security = get(rest, :security, nothing)
            if security !== nothing
                extensions = get(security, :extension, nothing)
                if extensions !== nothing
                    for extension in extensions
                        if get(extension, :url, nothing) ===
                           "http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris"
                            for url_value in extension.extension
                                if url_value.url === "token"
                                    return url_value.valueUri::String
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    error(
        "SMART configuration: Violation of the FHIR specification. The mandatory `token` url of the OAuth2 token endpoint is missing from the FHIR CompatibilityStatement.",
    )
end

# Ref: https://www.hl7.org/fhir/smart-app-launch/backend-services.html
"""
    backend_services(config::BackendServicesConfig)
"""
function backend_services(config::BackendServicesConfig)
    # Obtain the token endpoint: Try first the well-known URI and then the /metadata endpoint (deprecated)
    # On Julia >= 1.7 this can be simplified to
    # token_endpoint = @something _token_endpoint_wellknown(config) _token_endpoint_metadata(config) error("...")
    token_endpoint = _token_endpoint_wellknown(config)
    if token_endpoint === nothing
        token_endpoint = _token_endpoint_metadata(config)
        if token_endpoint === nothing
            # Ref: https://www.hl7.org/fhir/smart-app-launch/conformance.html#smart-on-fhir-oauth-authorization-endpoints-and-capabilities
            # Ref: https://hl7.org/fhir/smart-app-launch/1.0.0/conformance/index.html#smart-on-fhir-oauth-authorization-endpoints
            error(
                "SMART configuration: Violation of the FHIR specification. The FHIR server does neither convey its SMART capabilities using a Well-Known Uniform Resource Identifiers (URIs) JSON file nor its CapabilityStatement.",
            )
        end
    end

    # Obtain the access token
    # Ref: https://www.hl7.org/fhir/smart-app-launch/backend-services.html#obtain-access-token
    # Create JWT
    jwt = _backend_services_create_jwt(config, token_endpoint)

    body_params = Dict{String, String}()
    body_params["grant_type"] = "client_credentials"
    body_params["client_assertion_type"] = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
    body_params["client_assertion"] = jwt
    body_params["scope"] = config.scope

    _response = HTTP.request(
        "POST",
        token_endpoint;
        headers = ("Content-Type" => "application/x-www-form-urlencoded",),
        body = URIs.escapeuri(body_params),
    )

    access_token_response = JSON3.read(_response.body)
    access_token = access_token_response.access_token

    access_token_is_jwt, access_token_jwt_decoded = try_decode_jwt(access_token)

    backend_services_result = BackendServicesResult(;
        access_token             = access_token,
        access_token_is_jwt      = access_token_is_jwt,
        access_token_jwt_decoded = access_token_jwt_decoded,
        access_token_response    = access_token_response,
    )

    return backend_services_result
end
