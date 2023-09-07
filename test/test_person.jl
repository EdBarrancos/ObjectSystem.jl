using JuliaObjectSystem
using Test

@testset "Person" begin
    @defclass(SpecialMetaclass, [Class], [])

    @test class_of(SpecialMetaclass) === Class

    @defclass(Person, [],
    [name="John",
    [age, initform=40]],
    metaclass = SpecialMetaclass)

    @test class_of(Person) === SpecialMetaclass
    @test Person.direct_superclasses == [Object]

    p1 = new(Person)
    @test p1.name == "John"
    @test p1.age == 40
end