using ObjectSystem
using Test

@defclass(UndoableClass, [Class], [])

@defclass(Person, [],
    [[name, reader=get_name, writer=set_name!],
    [age, reader=get_age, writer=set_age!, initform=0],
    [friend, reader=get_friend, writer=set_friend!]],
    metaclass = UndoableClass)

@testset "Person" begin
    @test class_of(UndoableClass) === Class

    @test class_of(Person) === UndoableClass
    @test Person.direct_superclasses == [Object]


    @testset "Readers and Writers" begin
        p1 = new(Person, name="John Travolta", friend="Me")

        @testset "Readers" begin
            @test get_name(p1) == "John Travolta"
            @test get_friend(p1) == "Me"
            @test get_age(p1) == 0
        end

        @testset "Setters" begin
            set_name!(p1, "John Rambo")
            @test get_name(p1) == "John Rambo"
            @test p1.name == "John Rambo"

            p1.name = "Fernando"
            @test get_name(p1) == "Fernando"
            @test p1.name == "Fernando"
        end
    end
end