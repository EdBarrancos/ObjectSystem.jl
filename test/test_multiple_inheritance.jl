using JuliaObjectSystem
using Test
using Suppressor

@defclass(ColorMixin, [], [[color, reader=get_color, writer=set_color!]])

@defclass(Shape, [], [])
@defclass(Device, [], [])

@defgeneric draw(shape, device)

@defclass(Line, [Shape], [from, to])
@defclass(Circle, [Shape], [center, radius])

@defclass(Screen, [Device], [])
@defclass(Printer, [Device], [])

@defmethod draw(shape::Line, device::Screen) = println("Drawing a Line on Screen")
@defmethod draw(shape::Circle, device::Screen) = println("Drawing a Circle on Screen")
@defmethod draw(shape::Line, device::Printer) = println("Drawing a Line on Printer")
@defmethod draw(shape::Circle, device::Printer) = println("Drawing a Circle on Printer")

@defmethod draw(s::ColorMixin, d::Device) = begin
    previous_color = get_device_color(d)
    set_device_color!(d, get_color(s))
    call_next_method()
    set_device_color!(d, previous_color)
end

@defclass(ColoredLine, [ColorMixin, Line], [])
@defclass(ColoredCircle, [ColorMixin, Circle], [])
@defclass(ColoredPrinter, [Printer],
    [[ink=:black, reader=get_device_color, writer=_set_device_color!]])



@defmethod set_device_color!(d::ColoredPrinter, color) = begin
    println("Changing printer ink color to $color")
    _set_device_color!(d, color)
end

@testset "Multiple Inheritance" begin
    output = []
    let shapes = [new(Line), new(ColoredCircle, color=:red), new(ColoredLine, color=:blue)],
        printer = new(ColoredPrinter, ink=:black)
        for shape in shapes
            push!(output, @capture_out draw(shape, printer))
        end
    end

    @test output == [
        "Drawing a Line on Printer\n",
        "Changing printer ink color to red\n" *
        "Drawing a Circle on Printer\n" *
        "Changing printer ink color to black\n",
        "Changing printer ink color to blue\n" *
        "Drawing a Line on Printer\n" *
        "Changing printer ink color to black\n"
    ]
end

