using JuliaObjectSystem
using Test
using Suppressor

@testset "Built-In Classes" begin
    @testset "Print object" begin
        result = @capture_out show(class_of(1))
        @test result == "<BuiltInClass _Int64>" || result == "<BuiltInClass _Int32>"

        result = @capture_out show(class_of("Foo"))
        @test result == "<BuiltInClass _String>"
    end

    @defmethod add(a::_Int64, b::_Int64) = a + b
    @defmethod add(a::_Int32, b::_Int32) = a + b
    @defmethod add(a::_String, b::_String) = a * b

    @test add(1, 3) == 4
    @test add("Foo", "Bar") == "FooBar"
end