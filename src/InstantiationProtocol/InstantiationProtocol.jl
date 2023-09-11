export new, allocate_instance, initialize

allocate_instance = BaseStructure(
    GenericFunction,
    Dict(
        :name => slot_value_factory(:name, :allocate_instance),
        :lambda_list => slot_value_factory(:lambda_list, [:class]),
        :methods => slot_value_factory(:methods, [])
    )
)

create_method(
    allocate_instance,
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers => slot_value_factory(:specializers, [Class]),
            :procedure => slot_value_factory(:procedure, (call_next_method, class) -> begin
                return BaseStructure(
                    class,
                    Dict()
                )
            end),
            :generic_function => slot_value_factory(:generic_function, allocate_instance)
        )
    ))


initialize = BaseStructure(
    GenericFunction,
    Dict(
        :name => slot_value_factory(:name, :initialize),
        :lambda_list => slot_value_factory(:lambda_list, [:object, :initargs]),
        :methods => slot_value_factory(:methods, [])
    )
)

create_method(
    initialize, 
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers => slot_value_factory(:specializers, [Object, Top]),
            :procedure => slot_value_factory(:procedure, (call_next_method, object, initargs) -> begin
                class_slots = class_of(object).slots
                for slot in class_slots
                    target_value = slot.initform
                    if haskey(initargs, slot.name)
                        target_value = initargs[slot.name]
                    end

                    getter_setter =  compute_getter_and_setter(class_of(object), slot.name)
                
                    getfield(object, :slots)[slot.name] = SlotValue(
                        target_value,
                        (instance) -> getter_setter[begin](instance),
                        (instance, value) -> getter_setter[end](instance, value))
                end
            end),
            :generic_function => slot_value_factory(:generic_function, initialize)
        )
    ))

create_method(
    initialize, 
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers => slot_value_factory(:specializers, [Class, Top]),
            :procedure => slot_value_factory(:procedure, (call_next_method, class, initargs) -> begin
                class_slots = class_of(class).slots
                for slot in class_slots
                    target_value = slot.initform
                    if haskey(initargs, slot.name)
                        target_value = initargs[slot.name]
                    end

                    getter_setter =  compute_getter_and_setter(class_of(class), slot.name)
                    
                    getfield(class, :slots)[slot.name] = SlotValue(
                        target_value,
                        (instance) -> getter_setter[begin](instance),
                        (instance, value) -> getter_setter[end](instance, value))
                end
            end),
            :generic_function => slot_value_factory(:generic_function, initialize)
        )
    ))

create_method(
    initialize,
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers => slot_value_factory(:specializers, [MultiMethod, Top]),
            :procedure => slot_value_factory(:procedure, (call_next_method, method, initargs) -> begin
                call_next_method() # Class one
    
                create_method(
                    initargs[:generic_function],
                    method
                )
            end),
            :generic_function => slot_value_factory(:generic_function, initialize)
        )
    ))

new(class; initargs...) = begin
    check_for_polymorph(class, Class, ArgumentError)

    instance = allocate_instance(class)
    initialize(instance, initargs)
    return instance
end