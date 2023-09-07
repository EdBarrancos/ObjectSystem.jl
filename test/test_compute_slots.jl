using JuliaObjectSystem
using Test

@testset "Compute Slots" begin
    @testset "1 Level of Inheritance" begin
        @defclass(TestMetaclass, [Class], [])

        @test TestMetaclass.slots == Class.slots
    end
end