export new, allocate_instance, initialize

allocate_instance = BaseStructure(
    GenericFunction,
    Dict(
        :name=>:allocate_instance,
        :lambda_list=>[:class],
        :methods=>[]
    )
)

create_method(
    allocate_instance,
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers=>[Class],
            :procedure=>(call_next_method, class) -> begin
                return BaseStructure(
                    class,
                    Dict()
                )
            end,
            :generic_function=>allocate_instance
        )
    ))


initialize = BaseStructure(
    GenericFunction,
    Dict(
        :name=>:initialize,
        :lambda_list=>[:object, :initargs],
        :methods=>[]
    )
)

create_method(
    initialize, 
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers=>[Object, Top],
            :procedure=>(call_next_method, object, initargs) -> begin
                class_slots = class_of(object).slots
                for slot in class_slots
                    target_value = slot.initform
                    if haskey(initargs, slot.name)
                        target_value = initargs[slot.name]
                    end
            
                    getfield(object, :slots)[slot.name] = target_value
                end
            end,
            :generic_function=>initialize
        )
    ))

create_method(
    initialize, 
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers=>[Class, Top],
            :procedure=>(call_next_method, class, initargs) -> begin
                class_slots = class_of(class).slots
                for slot in class_slots
                    target_value = slot.initform
                    if haskey(initargs, slot.name)
                        target_value = initargs[slot.name]
                    end
                    
                    getfield(class, :slots)[slot.name] = target_value
                end
            end,
            :generic_function=>initialize
        )
    ))

create_method(
    initialize,
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers=>[MultiMethod, Top],
            :procedure=>(call_next_method, method, initargs) -> begin
                call_next_method() # Class one
    
                create_method(
                    initargs[:generic_function],
                    method
                )
            end,
            :generic_function=>initialize
        )
    ))

new(class; initargs...) = begin
    check_for_polymorph(class, Class, ArgumentError)

    instance = allocate_instance(class)
    initialize(instance, initargs)
    return instance
end