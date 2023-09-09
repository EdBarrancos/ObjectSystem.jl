using JuliaObjectSystem
using Test
using Suppressor

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

@testset "Test Multiple Dispatch" begin
    let devices = [new(Screen), new(Printer)],
        shapes = [new(Line), new(Circle)]
        for device in devices
            for shape in shapes
                result = @capture_out draw(shape, device)
                @test result == "Drawing a " * String(class_of(shape).name) * " on " * String(class_of(device).name) * "\n"
            end
        end
    end
end

