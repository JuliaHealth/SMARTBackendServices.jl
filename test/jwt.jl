is_jwt, jwt_decoded = SMARTBackendServices.try_decode_jwt("")
@test !is_jwt
@test jwt_decoded == Dict{String, Any}()
@test isempty(jwt_decoded)
