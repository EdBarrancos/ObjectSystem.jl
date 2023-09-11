using JuliaObjectSystem
using Test

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

@defclass(UndoableClass, [Class], [])
