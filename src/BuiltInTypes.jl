export @defbuiltin

@defclass(BuiltInClass, [Class], [])

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

@defbuiltin _Exception(Exception)
@defbuiltin _TypeException(Type{Exception})
@defbuiltin _Vector(Vector)
@defbuiltin _Tuple(Tuple)
@defbuiltin _Pair(Pair)
@defbuiltin _Symbol(Symbol)
@defbuiltin _KeywordArgument(Base.Pairs)