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

    println(getfield(simple_generic, :slots))

    create_method(simple_generic, simple_method)

    @test simple_generic() == 1
end

@testset "Overriding" begin
end

@testset "Unable to call non-function BaseStructure" begin
    
end

@testset "Calling function with wrong lambda_list" begin
    
end

@testset "Calling function with no methods" begin
    
end

@testset "Call Next method" begin
    
end
