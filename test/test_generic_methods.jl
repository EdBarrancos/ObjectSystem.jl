using ObjectSystem
using Test

@testset "Basic Method calling" begin
    @defgeneric simple_generic()

    @defmethod simple_generic() = begin
        return 1
    end

    @test simple_generic() == 1
end

@testset "Overriding" begin
    @defgeneric simple_generic()

    @defmethod simple_generic() = begin
        return 1
    end

    @defmethod simple_generic() = begin
        return 2
    end

    @test simple_generic() == 2
end

@testset "Unable to call non-function BaseStructure" begin
    @defclass(SimpleClass, [], [])

    @test_throws ArgumentError SimpleClass()
end

@testset "Calling function with wrong lambda_list" begin
    @defgeneric simple_generic()

    @defmethod simple_generic() = begin
        return 1
    end

    @test_throws ErrorException simple_generic(1)
end

@testset "Calling function with no methods" begin
    @defgeneric simple_generic()

    @test_throws ErrorException simple_generic()
end

@testset "Call Next method" begin
    @defclass(SimpleClass, [], [])

    @defgeneric simple_generic(a)

    @defmethod simple_generic(a::SimpleClass) = begin
        return call_next_method()
    end

    @defmethod simple_generic(a::Object) = begin
        return 2
    end

    simple = new(SimpleClass)

    @test simple_generic(simple) == 2
    check_class(simple, SimpleClass, Exception) #Shouldn't throw exception
    @test_throws Exception check_class(simple, Object)
    check_polymorph(simple, Object, Exception)
    @test is_class(simple, SimpleClass)
end
