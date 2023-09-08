"""
    BackendServicesConfig{T <: JWTs.JWK}(; kwargs...)

## Required Keyword Arguments:
- `iss::String`
- `key::T`
- `sub::String`
- `token_endpoint::String`

## Optional Keyword Arguments:
- `scope::Union{String, Nothing}`. Default value: `nothing`.
- `keyid::Union{String, Nothing}`. Default value: `nothing`.
"""
Base.@kwdef struct BackendServicesConfig{T <: JWTs.JWK}
    iss::String
    key::T
    keyid::Union{String, Nothing} = nothing
    scope::Union{String, Nothing} = nothing
    sub::String
    token_endpoint::String
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
