using JuliaObjectSystem
using Test

@testset "Compute Slots" begin
    @testset "1 Level of Inheritance" begin
        @defclass(TestMetaclass, [Class], [])

        @test TestMetaclass.slots == Class.slots
    end

    @testset "Collisions" begin
        @defclass(Foo, [], [a=1, b=2])
        @defclass(Bar, [], [b=3, c=4])
        @defclass(FooBar, [Foo, Bar], [a=5, d=6])

        @test class_slots(FooBar) == [:a, :d, :a, :b, :b, :c]

        foobar1 = new(FooBar)

        @test foobar1.a == 1
        @test foobar1.b == 3
        @test foobar1.c == 4
        @test foobar1.d == 6
    end
end

@defclass(AvoidCollisionClass, [Class], [])

@defmethod compute_slots(class::AvoidCollisionClass) = begin
    slots = call_next_method()
    duplicates = symdiff(slots, unique(slots))
    return isempty(duplicates) ?
        slots :
        error("Multiple occurrences of slots: $(join(map(string, duplicates), ", "))")
end

@defclass(Foo, [], [a=1, b=2])
@defclass(Bar, [], [b=3, c=4])
        
@test_throws Exception @defclass(FooBar, [Foo, Bar], [a=5, d=6], metaclass=AvoidCollisionClass)

