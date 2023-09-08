using JuliaObjectSystem
using Test

@testset "Person" begin
    @defclass(UndoableClass, [Class], [])

    @test class_of(UndoableClass) === Class

    @defclass(Person, [],
    [
        name="John",
        [age, initform=40],
        friend
    ],
    metaclass = UndoableClass)

    @test class_of(Person) === UndoableClass
    @test Person.direct_superclasses == [Object]

    p1 = new(Person)
    @test p1.name == "John"
    @test p1.age == 40
    @test ismissing(p1.friend)
end