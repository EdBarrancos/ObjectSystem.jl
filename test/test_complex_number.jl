using ObjectSystem
using Test

@defclass(ComplexNumber, [], [real=1, imag])
@defmethod print_object(c::ComplexNumber, io::_IO) = print(io, "$(c.real)$(c.imag < 0 ? "-" : "+")$(abs(c.imag))i")

@testset "Complex Number" begin
    @testset "Test class instantiation and slot access" begin
        c1 = new(ComplexNumber)

        @test class_of(c1) === ComplexNumber
        @test c1.real == 1
        @test ismissing(c1.imag)

        c2 = new(ComplexNumber, imag=3)
        @test c2.real == 1
        @test c2.imag == 3

        c3 = new(ComplexNumber, real=2, imag=5)
        @test c3.real == 2
        @test c3.imag == 5

        @testset "Slot Access" begin
            c3.real += 2
            c3.imag = 1
            @test c3.real == 4
            @test c3.imag == 1
        end
    end
    
    @defmethod add(c1::ComplexNumber, c2::ComplexNumber) = begin
        return new(ComplexNumber, real=c1.real + c2.real, imag=c1.imag + c2.imag)
    end

    @testset "Test add complex number" begin
        c1 = new(ComplexNumber, real=2, imag=5)

        c2 = add(c1, c1)

        @test class_of(c2) === ComplexNumber
        @test c2.real == 4
        @test c2.imag == 10
    end

    @testset "Print object" begin
        result = @capture_out show(ComplexNumber)
        @test result == "<Class ComplexNumber>"

        result = @capture_out show(add)
        @test result == "<GenericFunction add with 1 methods>"

        result = @capture_out show(add.methods[1])
        @test result == "<MultiMethod add(ComplexNumber, ComplexNumber)>"

        ob1 = new(Object)
        result = @capture_out show(ob1)
        @test result == "<Object " * repr(UInt64(pointer_from_objref(ob1))) * ">"
        
        c1 = new(ComplexNumber, real=2, imag=5)
        result = @capture_out show(c1)
        @test result == "2+5i"
    end

    @testset "MetaObject testing" begin
        @test ComplexNumber.direct_slots == [:real, :imag]
        @test class_of(ComplexNumber) === Class
        @test class_of(class_of(ComplexNumber)) === Class

        @test Class.slots == [:name, :direct_superclasses, :class_precedence_list, :direct_slots, :slots]

        @test ComplexNumber.name == :ComplexNumber
        @test ComplexNumber.direct_superclasses == [Object]

        @test class_of(add) === GenericFunction
        @test GenericFunction.slots == [:name, :lambda_list, :methods]

        @test class_of(add.methods[1]) === MultiMethod
        @test MultiMethod.slots == [:specializers, :procedure, :generic_function]
        @test add.methods[1].generic_function === add
    end
end