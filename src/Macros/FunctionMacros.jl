export @defgeneric, @defmethod

macro defgeneric(function_call)
    if typeof(function_call) != Expr
        error("Invalid syntax for defining generic function. Example: @defgeneric print_object(obj, io)")
    end

    if function_call.head != :call
        error("Invalid syntax for defining generic function. Example: @defgeneric print_object(obj, io)")
    end
    
    target_name = QuoteNode(function_call.args[begin])

    lambda_list = []
    if typeof(function_call.args[end]) == Expr && function_call.args[end].head == :(...)
        lambda_list = [lambda for lambda in function_call.args[end].args[begin]]
    else
        lambda_list = [lambda for lambda in function_call.args[2:end]]
    end

    return esc(
        quote
            $(function_call.args[begin]) = new(
                GenericFunction,
                name = $target_name,
                lambda_list = $(lambda_list),
                methods = []
            )
        end
    )
end


macro defmethod(method)
    if typeof(method) != Expr
        error("Invalid syntax for defining method. Example: @defmethod hello() = println(\"Hello\")")
    end

    if method.head != :(=)
        error("Missing body in method definition. Example: @defmethod hello() = println(\"Hello\")")
    end

    if typeof(method.args[begin]) != Expr && methpd.args[begin].head != :call
        error("Invalid syntax for defining method signature. Example: @defmethod hello() = println(\"Hello\")")
    end

    if typeof(method.args[end]) != Expr && methpd.args[end].head != :block
        error("Invalid syntax for defining method body. Example: @defmethod hello() = println(\"Hello\")")
    end

    lambda_list = []

    specializers = []

    for lambda in method.args[begin].args[2:end]
        if typeof(lambda) == Symbol
            push!(lambda_list, lambda)
            push!(specializers, Top)
        elseif lambda.head == :(::)
            push!(lambda_list, lambda.args[begin])
            push!(specializers, lambda.args[end])
        else
            error("Invalid syntax for method lambda_list. Example @defmethod add(a::ComplexNumber, b::ComplexNumber) = ...")
        end
    end

    lambda_list = Tuple(lambda_list)

    return esc(quote
        if ! @isdefined $(method.args[begin].args[begin])
            @defgeneric $(method.args[begin].args[begin])($(lambda_list)...)
        end

        new(
            MultiMethod,
            generic_function = $(method.args[begin].args[begin]),
            specializers = [$(specializers...)],
            procedure = (call_next_method, $(lambda_list...))->$(method.args[end])
        )

        $(method.args[begin].args[begin])
    end)
end