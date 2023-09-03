using JuliaObjectSystem
using Test

@testset "Basic Method calling" begin
    simple_generic = BaseStructure(
        GenericFunction,
        Dict(
            :name=>:simple_generic,
            :lambda_list=>[],
            :methods=>[]
        )
    )

    simple_method = BaseStructure(
        MultiMethod,
        Dict(
            :specializers=>[],
            :procedure=>(call_next_method) -> begin
                return 1
            end
            :generic_function=>simple_generic
        )
    )

    create_method(simple_generic, simple_method)

    @test simple_generic() == 1
end

@testset "Overriding" begin
    simple_generic = BaseStructure(
        GenericFunction,
        Dict(
            :name=>:simple_generic,
            :lambda_list=>[],
            :methods=>[]
        )
    )

    simple_method_1 = BaseStructure(
        MultiMethod,
        Dict(
            :specializers=>[],
            :procedure=>(call_next_method) -> begin
                return 1
            end
            :generic_function=>simple_generic
        )
    )

    simple_method_2 = BaseStructure(
        MultiMethod,
        Dict(
            :specializers=>[],
            :procedure=>(call_next_method) -> begin
                return 2
            end
            :generic_function=>simple_generic
        )
    )

    create_method(simple_generic, simple_method_1)
    @test simple_generic() == 1

    create_method(simple_generic, simple_method_2)
    @test simple_generic() == 2
end

@testset "Unable to call non-function BaseStructure" begin
    @defclass(SimpleClass, [], [])

    @test_throws ArgumentError SimpleClass()
end

@testset "Calling function with wrong lambda_list" begin
    simple_generic = BaseStructure(
        GenericFunction,
        Dict(
            :name=>:simple_generic,
            :lambda_list=>[],
            :methods=>[]
        )
    )

    simple_method = BaseStructure(
        MultiMethod,
        Dict(
            :specializers=>[],
            :procedure=>(call_next_method) -> begin
                return 1
            end
            :generic_function=>simple_generic
        )
    )

    create_method(simple_generic, simple_method)

    @test_throws ErrorException simple_generic(1)
end

@testset "Calling function with no methods" begin
    simple_generic = BaseStructure(
        GenericFunction,
        Dict(
            :name=>:simple_generic,
            :lambda_list=>[],
            :methods=>[]
        )
    )

    @test_throws ErrorException simple_generic()
end

@testset "Call Next method" begin
    @defclass(SimpleClass, [], [])

    simple_generic = BaseStructure(
        GenericFunction,
        Dict(
            :name=>:simple_generic,
            :lambda_list=>[:a],
            :methods=>[]
        )
    )

    simple_method_SimpleClass = BaseStructure(
        MultiMethod,
        Dict(
            :specializers=>[SimpleClass],
            :procedure=>(call_next_method, a) -> begin
                return call_next_method()
            end
            :generic_function=>simple_generic
        )
    )

    create_method(simple_generic, simple_method_SimpleClass)

    simple_method_Object = BaseStructure(
        MultiMethod,
        Dict(
            :specializers=>[Object],
            :procedure=>(call_next_method, a) -> begin
                return 2
            end
            :generic_function=>simple_generic
        )
    )

    create_method(simple_generic, simple_method_Object)

    SimpleClass_instance = BaseStructure(
        SimpleClass,
        Dict()
    )

    @test simple_generic(SimpleClass_instance) == 2
    check_class(SimpleClass_instance, SimpleClass, Exception) #Shouldn't throw exception
    @test_throws Exception check_class(SimpleClass_instance, Object)
    check_polymorph(SimpleClass_instance, Object, Exception)
    @test is_class(SimpleClass_instance, SimpleClass)
end
