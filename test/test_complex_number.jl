using JuliaObjectSystem
using Test

@testset "Complex Number" begin
    @defclass(ComplexNumber, [], [real=1, imag])

    @testset "Test class instantiation" begin
        c1 = new(ComplexNumber)

        @test class_of(c1) === ComplexNumber
        @test c1.real == 1
        @test ismissing(c1.imag)

        c2 = new(ComplexNumber, imag=3)
        @test c2.real == 1
        @test c2.imag == 3

        c3 = new(ComplexNumber, real=2, imag=5)
        @test c3.real == 2
        @test c3.imag == 5
    end
end