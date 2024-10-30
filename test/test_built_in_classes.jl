using ObjectSystem
using Test

@testset "Built-In Classes" begin
    @testset "Print object" begin
        result = @capture_out show(class_of(Int64(1)))
        @test result == "<BuiltInClass _Int64>"

        result = @capture_out show(class_of("Foo"))
        @test result == "<BuiltInClass _String>"
    end

    @defmethod add(a::_Int, b::_Int) = a + b
    @defmethod add(a::_String, b::_String) = a * b

    @test add(1, 3) == 4
    @test add("Foo", "Bar") == "FooBar"
end