export @defclass

macro defclass(name, superclasses, slots, options...)
    target_name = QuoteNode(name)
    
    #= Calculate Slots =#
    direct_slots_definition = []
    readers = []
    setters = []
    for slot in slots.args
        # TODO -> Reader and writer method
        if typeof(slot) != Expr
            # Just name of the slot defined
            push!(direct_slots_definition, SlotDefinition(slot, missing))
        elseif slot.head == :vect
            new_slot = SlotDefinition(:missing, missing)

            for option in slot.args
                if typeof(option) != Expr
                    # name of the slot
                    setfield!(new_slot, :name, option)
                elseif option.head == :(=)
                    if option.args[begin] == :reader
                        push!(readers, quote
                            local getter = compute_getter_and_setter($name, $(QuoteNode(new_slot.name)))[begin]
                            @defmethod $(option.args[end])(instance::$(name)) = getter(instance)
                        end)
                    elseif option.args[begin] == :writer
                        push!(setters, quote
                            local setter = compute_getter_and_setter($name, $(QuoteNode(new_slot.name)))[end]
                            @defmethod $(option.args[end])(instance::$(name), v) = setter(instance, v)
                        end)
                    elseif option.args[begin] == :initform
                        setfield!(new_slot, :initform, option.args[end])
                    else
                        new_slot = SlotDefinition(option.args[begin], option.args[end])
                    end
                end
            end

            push!(direct_slots_definition, new_slot)
        elseif slot.head == :(=)
            push!(direct_slots_definition, SlotDefinition(slot.args[begin], slot.args[end]))
        end
    end

    metaclass = Class
    for option in options
        if typeof(option) == Expr && option.head == :(=)
            if option.args[1] == :metaclass
                metaclass = option.args[end]
            else
                error("Unrecognized option")
            end
        else
            error("Invalid Option Syntax. Example: @defclass(SuperHuman, [], [], metaclass=SuperMetaClass)")
        end
    end
    
    
    return esc(
        quote 
            $name = new(
                $metaclass, 
                name = $target_name, 
                direct_superclasses = length($superclasses) > 0 ? $superclasses : [Object],
                direct_slots = $direct_slots_definition,
                class_precedence_list = [],
                slots = []
            )

            pushfirst!($name.class_precedence_list, $name)
            $name.class_precedence_list = compute_cpl($name)
            $name.slots = compute_slots($name)

            for reader in $(readers)
                eval(reader) # Not the hero we want, but the hero we could come up with
            end

            for setter in $(setters)
                eval(setter)
            end
            
            $name
        end
    )
end