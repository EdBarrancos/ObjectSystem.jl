using ObjectSystem
using Test

@testset "defclass" begin
    @testset "SimpleClass" begin
        @defclass(SimpleClass, [], [])

        @test isa(SimpleClass, BaseStructure)
        @test class_of(SimpleClass) === Class
        @test getfield(SimpleClass, :class_of_reference) === Class
        @test SimpleClass.name == :SimpleClass
        @test SimpleClass.direct_superclasses == [Object]
        @test SimpleClass.class_precedence_list == [SimpleClass, Object, Top]
        @test SimpleClass.slots == []
        @test SimpleClass.direct_slots == []
    end
end

