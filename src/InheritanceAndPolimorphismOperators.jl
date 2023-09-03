export check_class, check_polymorph, is_class

@defmethod is_class(instance::Object, targetClass::Class) = begin
    return class_of(instance) == targetClass
end

@defmethod check_polymorph(instance::Object, targetClass::Class, exception::_TypeException) = begin
    if !(targetClass in class_of(instance).class_precedence_list)
        throw(exception("Given '" * String(targetClass.name) * "' is not a " * String(targetClass.name)))
    end
end

@defmethod check_class(instance::Object, targetClass::Class, exception::_TypeException) = begin
    if !is_class(instance, targetClass)
        throw(exception("Given '" * String(targetClass.name) * "' is not a " * String(targetClass.name)))
    end
end