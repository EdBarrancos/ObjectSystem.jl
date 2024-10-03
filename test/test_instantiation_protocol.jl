using ObjectSystem
using Test

@testset "Sanity Test" begin
    @defclass(SimpleClass, [] , [])

    simple_instance = new(SimpleClass)
    @test class_of(simple_instance) === SimpleClass
    @test length(getfield(simple_instance, :slots)) == 0
end

@defclass(CountingClass, [Class], [counter=0])

@defmethod allocate_instance(class::CountingClass) = begin
    class.counter += 1
    call_next_method()
end

@defclass(Foo, [], [], metaclass=CountingClass)
@defclass(Bar, [], [], metaclass=CountingClass)

new(Foo)
new(Foo)
new(Bar)

@test Foo.counter == 2
@test Bar.counter == 1