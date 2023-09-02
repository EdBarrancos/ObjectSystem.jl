using JuliaObjectSystem
using Test

@testset "All Tests" begin
    include("test_baseJOS.jl")
    include("test_defclass.jl")
    include("test_generic_methods.jl")
end