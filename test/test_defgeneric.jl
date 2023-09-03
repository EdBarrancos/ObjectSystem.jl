using JuliaObjectSystem
using Test

@testset "defgeneric" begin
    @defgeneric simple_generic()

    @test class_of(simple_generic) === GenericFunction
    @test simple_generic.name == :simple_generic
    @test isempty(simple_generic.methods)
    @test isempty(simple_generic.lambda_list)
end
