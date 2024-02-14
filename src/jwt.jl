function try_decode_jwt(contents::AbstractString)
    try
        jwt_decoded = JWTs.claims(JWTs.JWT(; jwt = contents))
        return true, jwt_decoded
    catch
    end
    return false, Dict{String, Any}()
end
