function _backend_services_create_jwt(config::BackendServicesConfig)
    jti = Random.randstring(150)

    now = TimeZones.now(TimeZones.localzone())
    expiration_time = now + Dates.Minute(4)
    expiration_time_seconds_since_epoch_utc = integer_seconds_since_the_epoch_utc(expiration_time)

    jwt_payload_claims_dict = Dict(
        "iss" => config.iss,
        "sub" => config.sub,
        "aud" => config.token_endpoint,
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

"""
    backend_services(config::BackendServicesConfig)
"""
function backend_services(config::BackendServicesConfig)
    jwt = _backend_services_create_jwt(config)

    body_params = Dict{String, String}()
    body_params["grant_type"] = "client_credentials"
    body_params["client_assertion_type"] = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
    body_params["client_assertion"] = jwt

    if config.scope !== nothing
        body_params["scope"] = config.scope
    end

    _response = HTTP.request(
        "POST",
        config.token_endpoint;
        headers = Dict("Content-Type" => "application/x-www-form-urlencoded"),
        body = URIs.escapeuri(body_params),
    )

    access_token_response = JSON3.read(String(_response.body))
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
