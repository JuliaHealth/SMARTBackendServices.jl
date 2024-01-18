"""
    BackendServicesConfig{T <: JWTs.JWK}(; kwargs...)

## Required Keyword Arguments:
- `base_url`::String
- `client_id::String`
- `scope::String`
- `key::T`

## Optional Keyword Argument:
- `keyid::Union{String, Nothing}`. Default value: `nothing`.
"""
Base.@kwdef struct BackendServicesConfig{T <: JWTs.JWK}
    base_url::String
    client_id::String
    scope::String
    key::T
    keyid::Union{String, Nothing} = nothing
end

Base.@kwdef struct BackendServicesResult
    access_token::String
    access_token_is_jwt::Bool = false
    access_token_jwt_decoded::Dict{String, Any} = Dict{String, Any}()
    access_token_response::Dict{Symbol, Any}
end

"""
    HealthBase.get_fhir_access_token(result::BackendServicesResult)
"""
function HealthBase.get_fhir_access_token(result::BackendServicesResult)
    return result.access_token
end
