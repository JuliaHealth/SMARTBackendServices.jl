server = "https://launch.smarthealthit.org/v/r4/"
token_endpoint = server * "auth/token"

# Signing key
openid_config = String(HTTP.get(server * "fhir/.well-known/openid-configuration").body)
keyset = JWTs.JWKSet(JSON3.read(openid_config)["jwks_uri"])
JWTs.refresh!(keyset)
keyid, key = first(keyset.keys)
key = JWTs.JWKRSA(key.kind, MbedTLS.parse_keyfile(test_private_key))

client_id = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJwdWJfa2V5IjoiTFMwdExTMUNSVWRKVGlCUVZVSk1TVU1nUzBWWkxTMHRMUzBLVFVsSlFrbHFRVTVDWjJ0eGFHdHBSemwzTUVKQlVVVkdRVUZQUTBGUk9FRk5TVWxDUTJkTFEwRlJSVUYzWVdvMVoza3hkRXRvVGtOWVdYTjNOV0YzVkFwd1p5OVRja2xuYm1sU1YybElVVmwyZDFseWFrSk5WSHBYUkhkcGQyRTNXbkZLTDNSalRFTk5lR1Y1T0dRMlRHdDRWbkpoYldOb1lqWkdSMnhaZERaUkNtRnZNbkpRWlRSNGJVZ3hkak4zZW1kbVZqaEljbTFUTTI5R2NqbDRjRFJPTm5rNGNtdFdkekZ2Vmtoc2RqZHpVRTV0VlRkell5OHhhU3RJY1ZOUlRFb0thM3BWY1dOQ2FubzFVME14YkhwMlpYaG5jVzkxWjNKNGRUVk5abWwwTmtGd1pHRjFSVGc0U3k5dVNGVk9TM1l2T1ROWmFqTkNaM3BNSzBGV1UwUkpRUW92Ynpsc2VFVlplVmxHV1RBek5HaFJSVmhwVFVFME4yY3ZVRk5ZU20xU2NHWkRXV2hhVUc4MFNtTkdjRXBoU0V4amVGbGhiRmxVZUdSdVZDODVlREJuQ21sQlJETnJjMlZaY20wNFprd3JjRU5EY1V4bFdHbEZXVm94Y0d0R1pqWjFjMkZ5WVZScVMyeGlaSGxMWjJadEwyNWtWemR5V2xkemJVSkZSVVVyUWtVS01GRkpSRUZSUVVJS0xTMHRMUzFGVGtRZ1VGVkNURWxESUV0RldTMHRMUzB0Q2c9PSIsImlzcyI6Imh0dHBzOi8vd2hhdGV2ZXIuc21hcnQvb3VyLXNhbXBsZS1iYWNrZW5kLXNlcnZpY2UiLCJhY2Nlc3NUb2tlbnNFeHBpcmVJbiI6MSwiaWF0IjoxNTEwNzY2MTQzfQ.7YooXIb64Y3_j38n-Gqwa1PqXc-hz-4xJAJF5oqxJVo"

smart_config = BackendServicesConfig(;
    iss = "https://whatever.smart/our-sample-backend-service",
    sub = client_id,
    key,
    keyid,
    scope = "system/*.*",
    token_endpoint = token_endpoint,
)

smart_result = backend_services(smart_config)

@test smart_result isa SMARTBackendServices.BackendServicesResult

access_token = get_fhir_access_token(smart_result)

@test access_token isa AbstractString

@test length(access_token) > 1
