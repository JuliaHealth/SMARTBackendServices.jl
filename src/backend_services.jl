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
    if config.keyid === nothing
        JWTs.sign!(jwt, config.key)
    else
        JWTs.sign!(jwt, config.key, config.keyid)
    end
    @assert JWTs.issigned(jwt)
    @assert config.keyid === nothing || JWTs.kid(jwt) == config.keyid

    return string(jwt)
end

# Ref: https://www.hl7.org/fhir/smart-app-launch/backend-services.html
"""
    backend_services(config::BackendServicesConfig)
"""
function backend_services(config::BackendServicesConfig)
    # Retrieve the server configuration
    # Ref: https://www.hl7.org/fhir/smart-app-launch/backend-services.html#retrieve-well-knownsmart-configuration
    _config_response = HTTP.request(
        "GET",
        joinpath(config.base_url, ".well-known/smart-configuration");
        # In principle, it should be possible to omit the header
        # (and servers may ignore it anyway)
        # Ref: https://www.hl7.org/fhir/smart-app-launch/conformance.html#using-well-known
        headers = ("Accept" => "application/json",),
    )
    config_response = JSON3.read(_config_response.body)
    token_endpoint = get(config_response, :token_endpoint) do
        throw(ArgumentError("SMART configuration: `token_endpoint` is not specified"))    
    end::String

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
