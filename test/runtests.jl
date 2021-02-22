using SMARTBackendServices
using Test

import JSONWebTokens

include("test_private_key/create.jl")

@testset "SMARTBackendServices.jl" begin
    include("basic.jl")
    include("jwt.jl")
end

include("test_private_key/delete.jl")
