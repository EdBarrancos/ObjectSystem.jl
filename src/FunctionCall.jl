function (f::BaseStructure)(x...)
    check_for_polymorph(f, GenericFunction, ArgumentError)

    if length(x) != length(f.lambda_list)
        non_applicable_method(f, x)
    end

    return apply_methods(f, compute_effective_method(f, x), 1, x)
end

function apply_methods(generic_function::BaseStructure, effective_method_list::Vector, target_method_index::Integer,args::Tuple)
    check_for_polymorph(generic_function, GenericFunction, ArgumentError)

    if isempty(effective_method_list) || target_method_index > length(effective_method_list)
        non_applicable_method(generic_function, args)
    end

    #= Needs improvement in case of multiple calls =#
    return apply_method(target_method_index, args, effective_method_list, generic_function)
end

function apply_method(
    target_method_index::Integer, 
    args::Tuple, 
    methods::Vector, 
    generic_function::BaseStructure)

    check_for_polymorph(generic_function, GenericFunction, ArgumentError)
    check_for_polymorph(methods[target_method_index], MultiMethod, ArgumentError)

    method = methods[target_method_index]

    let call_next_method = () -> apply_methods(generic_function, methods, target_method_index + 1, args)
        return method.procedure(call_next_method, args...)
    end
end

function is_method_applicable(method::BaseStructure, x) 
    for i in range(1, length(x), step=1)
        if !any(
                (class) -> class === method.specializers[i],
                class_of(x[i]).class_precedence_list)
            return false
        end
    end

    return true
end

function is_method_more_specific(method1::BaseStructure, method2::BaseStructure, lambda)
    for i in range(1, length(lambda), step=1)
        index_spec1 = findfirst(
            (class) -> class === method1.specializers[i],
            class_of(lambda[i]).class_precedence_list)

        index_spec2 = findfirst(
            (class) -> class === method2.specializers[i],
            class_of(lambda[i]).class_precedence_list)

        if isnothing(index_spec2)
            return true
        elseif isnothing(index_spec1)
            return false
        elseif index_spec1 != index_spec2
            return index_spec1 <= index_spec2 
        end
    end

    #= Their the same =#
    return true
end

function compute_effective_method(f::BaseStructure, x)
    check_for_polymorph(f, GenericFunction, ArgumentError)

    applicable_methods = filter(
        method -> is_method_applicable(method, x), 
        f.methods)

    return sort(applicable_methods, lt=(method1, method2) -> is_method_more_specific(method1, method2, x))
end

