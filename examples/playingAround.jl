using JuliaObjectSystem

@defclass(Person, [],
    [
        name="John",
        [age, initform=40, reader=get_reader],
        friend
    ])

println(get_reader)
