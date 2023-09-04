using JuliaObjectSystem

@defclass(SimpleClass, [], [])

new(Class, name=:SimpleClass, slots="HAPPY")


f() = begin
    let a = 1
        return a
    end
end

f()
