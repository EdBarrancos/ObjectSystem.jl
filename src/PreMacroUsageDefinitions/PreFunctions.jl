export non_applicable_method

non_applicable_method = BaseStructure(
    GenericFunction,
    Dict(
        :name=>:non_applicable_method,
        :lambda_list=>[:generic_function, :args],
        :methods=>[]
    )
)

non_applicable_method_method = BaseStructure(
    MultiMethod,
    Dict(
        :specializers=>[GenericFunction, Top],
        :procedure=>(call_next_method, generic_function, args) -> begin
            println("LOOK AT ME")
            error(
                "No applicable method for function ",
                getfield(generic_function, :slots)[:name],
                " with arguments ",
                string(args))
        end
        :generic_function=>non_applicable_method
    )
)

create_method(non_applicable_method, non_applicable_method_method)