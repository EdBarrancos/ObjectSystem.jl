using ObjectSystem
using Test

@testset "defgeneric" begin
    @defgeneric simple_generic()

    @test class_of(simple_generic) === GenericFunction
    @test simple_generic.name == :simple_generic
    @test isempty(simple_generic.methods)
    @test isempty(simple_generic.lambda_list)
end

@testset "defmethod" begin
    @testset "simple test" begin
        @defgeneric simple_generic()

        @defmethod simple_generic() = begin
            return 1
        end

        @test simple_generic() == 1
    end

   
    @testset "definining a method without an existing generic" begin
        @defmethod simple_empty_generic() = begin
            return 1
        end
        
        @test simple_empty_generic() == 1
        @test class_of(simple_empty_generic) === GenericFunction
        @test length(simple_empty_generic.methods) == 1
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

    @testset "Call next method" begin
        @defclass(SimpleClass, [], [])

        @defgeneric simple_generic(a)

        @defmethod simple_generic(a::SimpleClass) = begin
            return call_next_method()
        end

        @defmethod simple_generic(a::Object) = begin
            return 2
        end

        @defmethod simple_generic(a::Top) = begin
            return 3
        end

        SimpleClass_instance = BaseStructure(
            SimpleClass,
            Dict()
        )

        @test simple_generic(SimpleClass_instance) == 2
    end
end
