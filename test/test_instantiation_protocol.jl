using JuliaObjectSystem
using Test

@testset "Sanity Test" begin
    @defclass(SimpleClass, [] , [])

    simple_instance = new(SimpleClass)
    @test class_of(simple_instance) === SimpleClass
    @test length(getfield(simple_instance, :slots)) == 0
end

