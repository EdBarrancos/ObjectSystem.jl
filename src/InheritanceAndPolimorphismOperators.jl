export check_class, check_for_polymorph

check_for_polymorph(instance::BaseStructure, targetClass::BaseStructure, exception) = begin
    if !(targetClass in class_of(instance).class_precedence_list)
        throw(exception("Given '" * String(targetClass.name) * "' is not a " * String(targetClass.name)))
    end
end

check_class(instance::BaseStructure, targetClass::BaseStructure, exception) = begin
    if class_of(instance) != targetClass
        throw(exception("Given '" * String(targetClass.name) * "' is not a " * String(targetClass.name)))
    end
end