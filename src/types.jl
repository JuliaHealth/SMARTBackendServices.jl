"""
    BackendServicesConfig{PK}(; kwargs...)

## Required Keyword Arguments:
- `iss::String`
- `private_key::PK`
- `sub::String`
- `token_endpoint::String`

## Optional Keyword Arguments:
- `scope::Union{String, Nothing}`. Default value: `nothing`.
"""
Base.@kwdef struct BackendServicesConfig{PK <: JSONWebTokens.Encoding}
    iss::String
    private_key::PK
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
    get_access_token(result::BackendServicesResult)
"""
function get_access_token(result::BackendServicesResult)
    return result.access_token::String
end
