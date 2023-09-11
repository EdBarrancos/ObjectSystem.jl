export GenericFunction, MultiMethod, create_method

GenericFunction = BaseStructure(
    Class,
    Dict(
        :name => slot_value_factory(:name, :GenericFunction),
        :direct_superclasses => slot_value_factory(:direct_superclasses, [Object]), 
        :direct_slots => slot_value_factory(:direct_slots, [
            SlotDefinition(:name, missing),
            SlotDefinition(:lambda_list, missing), 
            SlotDefinition(:methods, [])
        ]),
        :class_precedence_list => slot_value_factory(:class_precedence_list, [Object, Top]),
        :slots => slot_value_factory(:slots, [
            SlotDefinition(:name, missing),
            SlotDefinition(:lambda_list, missing), 
            SlotDefinition(:methods, [])
        ])
    )
)

pushfirst!(getfield(GenericFunction, :slots)[:class_precedence_list].value, GenericFunction)

MultiMethod = BaseStructure(
    Class,
    Dict(
        :name => slot_value_factory(:name, :MultiMethod),
        :direct_superclasses => slot_value_factory(:direct_superclasses, [Object]), 
        :direct_slots => slot_value_factory(:direct_slots, [
            SlotDefinition(:specializers, missing),
            SlotDefinition(:procedure, missing),
            SlotDefinition(:generic_function, missing)
        ]),
        :class_precedence_list => slot_value_factory(:class_precedence_list, [Object, Top]),
        :slots => slot_value_factory(:direct_slots, [
            SlotDefinition(:specializers, missing),
            SlotDefinition(:procedure, missing),
            SlotDefinition(:generic_function, missing)
        ])
    )
)

pushfirst!(getfield(MultiMethod, :slots)[:class_precedence_list].value, MultiMethod)

function create_method(
    parent_generic_function::BaseStructure, 
    new_method::BaseStructure)

    check_for_polymorph(parent_generic_function, GenericFunction, ArgumentError)
    check_for_polymorph(new_method, MultiMethod, ArgumentError)

    if !isequal(
        length(parent_generic_function.lambda_list),
        length(new_method.specializers))

        error("Method does not correspond to generic function's signature")
    end
    
    #= override =#
    filter!(
        (method) -> 
            !(isequal(
                new_method.specializers,
                method.specializers)),
        parent_generic_function.methods)
        
    pushfirst!(parent_generic_function.methods, new_method)
end

check_for_polymorph(instance::BaseStructure, targetClass::BaseStructure, exception) = begin
    if !(targetClass in class_of(instance).class_precedence_list)
        throw(exception("Given '" * String(targetClass.name) * "' is not a " * String(targetClass.name)))
    end
end