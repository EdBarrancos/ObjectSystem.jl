export non_applicable_method

@defmethod non_applicable_method(generic_function::GenericFunction, args::_Tuple) = begin
    error(
        "No applicable method for function ",
        getfield(generic_function, :slots)[:name],
        " with arguments ",
        string(args))
end
