using SMARTBackendServices
using Test

import JWTs
import MbedTLS

@testset "SMARTBackendServices.jl" begin
    include("basic.jl")
    include("jwt.jl")
end
