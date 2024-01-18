using SMARTBackendServices
using Test

import JSON3
import JWTs
import HTTP
import MbedTLS

include("test_private_key/create.jl")

@testset "SMARTBackendServices.jl" begin
    include("basic.jl")
    include("jwt.jl")
end

include("test_private_key/delete.jl")
