export @defbuiltin

macro defbuiltin(typeDefinition) 
    if typeof(typeDefinition) != Expr
        error("Invalid macro signature. Example @defbuiltin _Int8(Int8)")
    end

    if typeDefinition.head != :call
        error("Invalid macro signature. Example @defbuiltin _Int8(Int8)")
    end

    return esc(quote
        @defclass($(typeDefinition.args[begin]), [Top], [], metaclass=BuiltInClass)
        class_of(instance::$(typeDefinition.args[end])) = $(typeDefinition.args[begin])
        $(typeDefinition.args[begin])
    end)
end