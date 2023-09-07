export non_applicable_method, compute_slots

non_applicable_method = BaseStructure(
    GenericFunction,
    Dict(
        :name=>:non_applicable_method,
        :lambda_list=>[:generic_function, :args],
        :methods=>[]
    )
)

create_method(
    non_applicable_method, 
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers=>[GenericFunction, Top],
            :procedure=>(call_next_method, generic_function, args) -> begin
                error(
                    "No applicable method for function ",
                    getfield(generic_function, :slots)[:name],
                    " with arguments ",
                    string(args))
            end,
            :generic_function=>non_applicable_method
        )
    ))

compute_slots = BaseStructure(
    GenericFunction,
    Dict(
        :name=>:compute_slots,
        :lambda_list=>[:class],
        :methods=>[]
    )
)

create_method(
    compute_slots,
    BaseStructure(
        MultiMethod,
        Dict(
            :specializers=>[Class],
            :procedure=>(call_next_method, class) -> begin
                return vcat(
                    map(
                        (target_class) -> getfield(target_class, :slots)[:direct_slots], 
                        getfield(class, :slots)[:class_precedence_list])...)
            end
        )
    )
)