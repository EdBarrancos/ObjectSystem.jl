export class_of, assert_subclass_of, class_name, class_direct_slots, class_slots, 
    class_direct_superclasses, class_cpl, check_class, check_polymorph, is_class,
    generic_methods, method_specializers

class_of(instance::BaseStructure) = begin
    getfield(instance, :class_of_reference)
end

assert_subclass_of(instance, targetClass, exception) = begin
    if !(targetClass in getfield(class_of(instance), :slots)[:class_precedence_list])
        throw(exception("Given " * String(getfield(targetClass, :slots)[:name]) * " is not a " * String(getfield(targetClass, :slots)[:name])))
    end
end

class_name(class::BaseStructure) = begin
    assert_subclass_of(class, Class, ArgumentError)
    return getfield(class, :slots)[:name]
end

class_direct_slots(class::BaseStructure) = begin
    assert_subclass_of(class, Class, ArgumentError)
    return getfield(class, :slots)[:direct_slots]
end

class_slots(class::BaseStructure) = begin
    assert_subclass_of(class, Class, ArgumentError)
    return getfield(class, :slots)[:slots]
end

class_direct_superclasses(class::BaseStructure) = begin
    assert_subclass_of(class, Class, ArgumentError)
    return getfield(class, :slots)[:direct_superclasses]
end

class_cpl(class::BaseStructure) = begin
    assert_subclass_of(class, Class, ArgumentError)
    return getfield(class, :slots)[:class_precedence_list]
end

generic_methods(generic::BaseStructure) = begin
    assert_subclass_of(generic, GenericFunction, ArgumentError)
    return getfield(generic, :slots)[:methods]
end

method_specializers(method::BaseStructure) = begin
    assert_subclass_of(method, MultiMethod, ArgumentError)
    return getfield(method, :slots)[:specializers]
end

is_class(instance::BaseStructure, targetClass::BaseStructure) = begin
    return class_of(instance) === targetClass
end

check_polymorph(instance::BaseStructure, targetClass::BaseStructure, exception::Type{Exception}) = begin
    if !(targetClass in class_of(instance).class_precedence_list)
        throw(exception("Given '" * String(targetClass.name) * "' is not a " * String(targetClass.name)))
    end
end

check_class(instance::BaseStructure, targetClass::BaseStructure, exception::Type{Exception}) = begin
    if !is_class(instance, targetClass)
        throw(exception("Given '" * String(targetClass.name) * "' is not a " * String(targetClass.name)))
    end
end