export non_applicable_method, compute_slots, compute_cpl, compute_getter_and_setter

non_applicable_method = BaseStructure(
    GenericFunction,
    Dict(
        :name => slot_value_factory(:name, :non_applicable_method),
        :lambda_list => slot_value_factory(:lambda_list, [:generic_function, :args]),
        :methods => slot_value_factory(:methods, [])
    )
)

create_method(
    non_applicable_method, 
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers => slot_value_factory(:specializers, [GenericFunction, Top]),
            :procedure => slot_value_factory(:procedure, (call_next_method, generic_function, args) -> begin
                error(
                    "No applicable method for function ",
                    generic_function.name,
                    " with arguments ",
                    string(args))
            end),
            :generic_function => slot_value_factory(:generic_function, non_applicable_method)
        )
    ))

compute_slots = BaseStructure(
    GenericFunction,
    Dict(
        :name => slot_value_factory(:name, :compute_slots),
        :lambda_list => slot_value_factory(:lambda_list, [:class]),
        :methods => slot_value_factory(:methods, [])
    )
)

create_method(
    compute_slots,
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers => slot_value_factory(:specializers, [Class]),
            :procedure => slot_value_factory(:procedure, (call_next_method, class) -> begin
                return vcat(
                    map(
                        (target_class) -> target_class.direct_slots, 
                            class.class_precedence_list)...)
            end),
            :generic_function => slot_value_factory(:generic_function, compute_slots)
        )
    )
)

compute_cpl = BaseStructure(
    GenericFunction,
    Dict(
        :name => slot_value_factory(:name, :compute_cpl),
        :lambda_list => slot_value_factory(:lambda_list, [:class]),
        :methods => slot_value_factory(:methods, [])
    )
)

create_method(
    compute_cpl,
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers => slot_value_factory(:specializers, [Class]),
            :procedure => slot_value_factory(:procedure, (call_next_method, class) -> begin
                queue = [class]
                class_precedence_list = [class]
                while !isempty(queue)
                    target = popfirst!(queue)
                    target_direct_superclasses = filter(
                        (superclass) -> !(superclass in class_precedence_list),
                        target.direct_superclasses)
                    class_precedence_list = vcat(class_precedence_list, target_direct_superclasses)
                    queue = vcat(queue, target_direct_superclasses)
                end

                return class_precedence_list
            end),
            :generic_function => slot_value_factory(:generic_function, compute_cpl)
        )
    )
)

compute_getter_and_setter = BaseStructure(
    GenericFunction,
    Dict(
        :name => slot_value_factory(:name, :compute_getter_and_setter),
        :lambda_list => slot_value_factory(:lambda_list, [:class, :slot]),
        :methods => slot_value_factory(:methods, [])
    )
)

create_method(
    compute_getter_and_setter,
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers => slot_value_factory(:specializers, [Class, _Symbol]),
            :procedure => slot_value_factory(:procedure, (call_next_method, class, slot) -> begin
                getter = (instance) -> return getfield(instance, :slots)[slot].value
                setter = (instance, new_value) -> begin
                    actual_slot = getfield(instance, :slots)[slot]
                    actual_slot.value = new_value
                end
                return (getter, setter)
            end),
            :generic_function => slot_value_factory(:generic_function, compute_getter_and_setter)
        )
    )
)

#= create_method(
    compute_getter_and_setter,
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers => slot_value_factory(:specializers, [Object, _Symbol]),
            :procedure => slot_value_factory(:procedure, (call_next_method, class, slot) -> begin
                getter = (instance) -> return getfield(instance, :slots)[slot].value
                setter = (instance, new_value) -> begin
                    actual_slot = getfield(instance, :slots)[slot]
                    actual_slot.value = new_value
                end
                return (getter, setter)
            end),
            :generic_function => slot_value_factory(:generic_functions, compute_getter_and_setter)
        )
    )
) =#