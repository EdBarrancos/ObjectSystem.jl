using ObjectSystem
using Test

@defclass(UndoableClass, [Class], [])

@defmethod compute_getter_and_setter(class::UndoableClass, slot) =
    let (getter, setter) = call_next_method()
    (getter,
    (o, v)->begin
        if save_previous_value
            store_previous(o, slot, getter(o))
        end
        setter(o, v)
    end)
end

@defclass(AvoidCollisionClass, [Class], [])

function nonunique(x::AbstractArray{T}) where T
    uniqueset = Set{T}()
    duplicatedset = Set{T}()
    duplicatedvector = Vector{T}()
    for i in x
        if(i in uniqueset)
            if !(i in duplicatedset)
                push!(duplicatedset, i)
                push!(duplicatedvector, i)
            end
        else
            push!(uniqueset, i)
        end
    end
    duplicatedvector
end

@defmethod compute_slots(class::AvoidCollisionClass) = begin
    slots = call_next_method()
    return length(slots) == length(unique(slots))  ?
        slots :
        error("Multiple occurrences of slots: $(join(map(string, nonunique(slots)), ", "))")
end

@defclass(CountingClass, [Class], [counter=0])

@defmethod allocate_instance(class::CountingClass) = begin
    class.counter += 1
    call_next_method()
end

@defclass(UndoableCollisionAvoidingCountingClass,
    [UndoableClass, AvoidCollisionClass, CountingClass],
    [])

@defclass(NamedThing, [], [name])

@test_throws Exception @defclass(Person, [NamedThing], 
    [name, age, friend], 
    metaclass=UndoableCollisionAvoidingCountingClass)

@defclass(Person, [NamedThing], 
    [age, friend], 
    metaclass=UndoableCollisionAvoidingCountingClass)

@defmethod print_object(p::Person, io) =
    print(io, "[$(p.name), $(p.age)$(ismissing(p.friend) ? "" : " with friend $(p.friend)")]")

undo_trail = []

store_previous(object, slot, value) = push!(undo_trail, (object, slot, value))

current_state() = length(undo_trail)

restore_state(state) =
    while length(undo_trail) != state
        restore(pop!(undo_trail)...)
    end

save_previous_value = true

restore(object, slot, value) =
    let previous_save_previous_value = save_previous_value
        global save_previous_value = false
        try
            setproperty!(object, slot, value)
        finally
            global save_previous_value = previous_save_previous_value
        end
    end



@testset "Test For UndoableClass" begin
    p0 = new(Person, name="John", age=21)
    p1 = new(Person, name="Paul", age=23)
    
    p1.friend = p0
    
    result = @capture_out println(p1)
    @test result == "[Paul, 23 with friend [John, 21]]\n"
    
    state0 = current_state()
    #32 years later, John changed his name to 'Louis' and got a friend
    p0.age = 53
    p1.age = 55
    p0.name = "Louis"
    p0.friend = new(Person, name="Mary", age=19)
    
    result = @capture_out println(p1)
    @test result == "[Paul, 55 with friend [Louis, 53 with friend [Mary, 19]]]\n"
    
    state1 = current_state()
    
    #15 years later, John (hum, I mean 'Louis') died
    p1.age = 70
    p1.friend = missing
    
    result = @capture_out println(p1)
    @test result == "[Paul, 70]\n"
    
    #Let's go back in time
    restore_state(state1)
    result = @capture_out println(p1)
    @test result == "[Paul, 55 with friend [Louis, 53 with friend [Mary, 19]]]\n"
    
    #And even earlier
    restore_state(state0)
    result = @capture_out println(p1)
    @test result == "[Paul, 23 with friend [John, 21]]\n" 
end

@test Person.counter == 3
