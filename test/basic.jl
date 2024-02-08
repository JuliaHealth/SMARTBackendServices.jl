# This test uses the public https://launch.smarthealthit.org test server
#
# In the webinterface, select "Launch Type": "Backend Service"
# and then switch to the "Client Registration & Validation" tab
#
# There you can register a client (with randomly generated ID),
# possibly restricted to some scope,
# with a JWK set of public keys for authentication.
#
# Use the base URL at the bottom of the page to connect to the
# server with the stated client ID, scope, and keys. 
#
# A private key together with a public JWK set can be generated
# e.g. with https://mkjwk.org/ (alternatively, you can e.g.
# generate the key with openssl and create the JWK set manually):
# 1. Select "Key Use": "Signature"
# 2. Select "Algorithm": "RS384"
# 3. Specify a key id (or let it be generated automatically)
# 4. Check "Show X.509"
# 5. Press "Generate"
# 6. Insert the public key (in JSON format) in the "keys" array in ./key/public_jwkset.json
# 7. Save the private key (in X.509 format) as ./key/private.pem

# Settings of the registered client
base_url = "https://launch.smarthealthit.org/v/r4/sim/WzQsIiIsIiIsIiIsMCwwLDAsInN5c3RlbS8qLnJzIiwiIiwiM240M3JpV29zZjdnZUJrWkJ1eWJndkgzTVo3WEhDbnNRMnc2MFRJbDUxa3ZDb2hoeXBWaTc2R0tqUGNZWnFlS3d3NXhnaGZrWE9OOUNXWmUyNGRjRDUxdmdGc3hRcFd5S3UyMzF1YXplcjk1NjJSQVV2VEZZOVFtc3dhZDMzenZYb21OVDlXcEFmTnZ0TmN2aE96T3dkclpaMW1ZQ1Y1cEhmWllZWEpIdlB6N21uR3Zybm52SFVXMVZBTWF5WmYzOGRNOGNZM003djVoaGIyT1hhYmd0WEJUYWJ4OEhvMnJHT2NhS1pHY0RwZHM4a2ZjYUlmREpJb0pENkY3Mk1DUzJQcEI4VW9NMnRzSkZBTk13VUNpVEVvTW5sdXUzSmJQT2tmeTVIdmNlcG1YYVZmQzVQZXlGN0xMVEhnOGVQVFAxV1FYT0R1ZHQ4YmllcFVtZHN2OWVUM0ptUFlJdzRLQ25HbEx2TzhXRktyUXF3ejE4S080RGpTY0hJTFVqUXpEZkdHampYQlVaNXY2bUtvSHV2RXlJMWlqQkNQcDROdlAyOWNFVVFqY3hISTIyU0tua1ZmTFhFSzd3MW1kUmx2akFGT3VNdkpvRVJNYjlIZzYzT1AzaUdCbjExMnIwWFVoSGpHdXpFYjloTmM2M2trVVhJSGtEcUQxUEthVHhvUnExYWZHc3RhNEl0cjM2bUpRVDRPd2N3ZWxLdVgyRjMyZ3VQem92R0E1d0liRzVJNmlvcHA2YTdpbkllSWdnODR3SDVEVlB3UkdyNVRyNEdCdHhwaHRuU3I5dFd6REEwbm9YOVZoRjRBZWhZTWRHMnh0YlZHbWtFUlJzMFBLR0hwUVVZWFo3WURreGt6S3dudmVvazRsSlM3M2ZSaXRXY2dCWmkxVGFWV1pQT1ZzMnJsWFZEVzU3azg3aDFyemFvZmd2WUZwZkdPZGZIbVA4N28yVlhBUThYWW5XOFRIb0x4d2NkSUNuVjltWTB4WjhZbnVLUjM4WHZFaVBseGF4NVpGNzdZUTVzUGJGeTUzUnU2Q2kyRGx5NnZVOXF1dVRWSzNNSmFRSTFJVWZScUxRRndVaXZ0WGw3aUZESDBtUFdRVXM1c2tSelhLUUVjbkxWUjJmVTBUVnQzOU1YNVduU1Bnb2VOVnd4dDg0aHNzZU9LYkZKelptR1hTalNjYkZMRHFVTjNES0gwN0tIS09zMGVNSVlHdzBkbm5sdmpsUU00TlRsZ1R5b2dJZmdCd0xmQ2VYdVRkRUhCWGtJbU5DRERxTktzeFZTOWlyVkNXdlpjRFR4anJZN250MWZQVzNXb0dmR1ZqeG0ycTVhbzcxYm1NSElyeEh1dU93azFHMUMxeiIsIiIsIiIsIiIsIntcImtleXNcIjogW3tcbiAgICBcImt0eVwiOiBcIlJTQVwiLFxuICAgIFwiZVwiOiBcIkFRQUJcIixcbiAgICBcInVzZVwiOiBcInNpZ1wiLFxuICAgIFwia2lkXCI6IFwiWWIwOWhURENxbW8wVXR0U2NGT2YzN1Z6eDE5amlEbGJuellRWUF2NnVYa1wiLFxuICAgIFwiYWxnXCI6IFwiUlMzODRcIixcbiAgICBcIm5cIjogXCJ2NHBUS0dxeng1b3JELVc4YzBkRkt5Nm15TEh0NEtlekVfeE5WenZXUFdvMUR3V0ozTXRtS1BuYnJiclB0MHBOaHVPVHVBLXp4RWR1U1o5MldsTGlNLWE5TEhVXzVMdm1jTTV6UHFjd2pwOGE1SWFyaVdieC03NE9rd1k1Nk04MEpLWlVReVZ0czNsTE5Kdi05aHpUS0J0aGVRTl92RkZOdk00ck9ueUphTE1tUENWY1Q4MXE5VUlhWHRnQWhLQ3BHdFpiZlZFbEFMR1lqeUZtYjdpTzBMWDROb1FheU1vSlhLY3FGbmY2N0dqRnB3ZzhqTVkxaGliT1J1eVJ5YVlNdUowWkpWcUFhdXp1dnVsaUxyMUx0R1BWZ292ZXdVRFV0LWtnTkZ6SGRDNmNjVF9Ed3BHbXpsR2twQjJ5ZEJ1T2NjbGxJa1NTbndYM3NvZ1NkX0dzbndcIlxufV19IiwyLDFd/fhir"
client_id = "3n43riWosf7geBkZBuybgvH3MZ7XHCnsQ2w60TIl51kvCohhypVi76GKjPcYZqeKww5xghfkXON9CWZe24dcD51vgFsxQpWyKu231uazer9562RAUvTFY9Qmswad33zvXomNT9WpAfNvtNcvhOzOwdrZZ1mYCV5pHfZYYXJHvPz7mnGvrnnvHUW1VAMayZf38dM8cY3M7v5hhb2OXabgtXBTabx8Ho2rGOcaKZGcDpds8kfcaIfDJIoJD6F72MCS2PpB8UoM2tsJFANMwUCiTEoMnluu3JbPOkfy5HvcepmXaVfC5PeyF7LLTHg8ePTP1WQXODudt8biepUmdsv9eT3JmPYIw4KCnGlLvO8WFKrQqwz18KO4DjScHILUjQzDfGGjjXBUZ5v6mKoHuvEyI1ijBCPp4NvP29cEUQjcxHI22SKnkVfLXEK7w1mdRlvjAFOuMvJoERMb9Hg63OP3iGBn112r0XUhHjGuzEb9hNc63kkUXIHkDqD1PKaTxoRq1afGsta4Itr36mJQT4OwcwelKuX2F32guPzovGA5wIbG5I6iopp6a7inIeIgg84wH5DVPwRGr5Tr4GBtxphtnSr9tWzDA0noX9VhF4AehYMdG2xtbVGmkERRs0PKGHpQUYXZ7YDkxkzKwnveok4lJS73fRitWcgBZi1TaVWZPOVs2rlXVDW57k87h1rzaofgvYFpfGOdfHmP87o2VXAQ8XYnW8THoLxwcdICnV9mY0xZ8YnuKR38XvEiPlxax5ZF77YQ5sPbFy53Ru6Ci2Dly6vU9quuTVK3MJaQI1IUfRqLQFwUivtXl7iFDH0mPWQUs5skRzXKQEcnLVR2fU0TVt39MX5WnSPgoeNVwxt84hsseOKbFJzZmGXSjScbFLDqUN3DKH07KHKOs0eMIYGw0dnnlvjlQM4NTlgTyogIfgBwLfCeXuTdEHBXkImNCDDqNKsxVS9irVCWvZcDTxjrY7nt1fPW3WoGfGVjxm2q5ao71bmMHIrxHuuOwk1G1C1z"
scope = "system/*.rs"

# Signing key
keyset = JWTs.JWKSet("file://$(@__DIR__)/key/public_jwkset.json")
JWTs.refresh!(keyset)
keyid, key = only(keyset.keys)
key = JWTs.JWKRSA(key.kind, MbedTLS.parse_keyfile(joinpath(@__DIR__, "key", "private.pem")))

smart_config = BackendServicesConfig(; base_url, client_id, key, keyid, scope)
smart_config_wo_keyid = BackendServicesConfig(; base_url, client_id, key, scope)

for smart_config in (smart_config, smart_config_wo_keyid)
    smart_result = backend_services(smart_config)
    @test smart_result isa SMARTBackendServices.BackendServicesResult

    access_token = get_fhir_access_token(smart_result)
    @test access_token isa AbstractString
    @test length(access_token) > 1
end

@testset "token_endpoint" begin
    # Correct settings
    token_endpoint_wellknown = SMARTBackendServices._token_endpoint_wellknown(smart_config)
    @test token_endpoint_wellknown isa String
    token_endpoint_metadata = SMARTBackendServices._token_endpoint_metadata(smart_config)
    @test token_endpoint_metadata isa String
    @test token_endpoint_metadata === token_endpoint_wellknown

    # Incorrect base url
    config = BackendServicesConfig(; base_url = "https://google.com", client_id, key, keyid, scope)
    @test SMARTBackendServices._token_endpoint_wellknown(config) === nothing
    @test SMARTBackendServices._token_endpoint_metadata(config) === nothing
    @test_throws ErrorException("SMART configuration: Violation of the FHIR specification. The FHIR server does neither convey its SMART capabilities using a Well-Known Uniform Resource Identifiers (URIs) JSON file nor its CapabilityStatement.") backend_services(config)
end
