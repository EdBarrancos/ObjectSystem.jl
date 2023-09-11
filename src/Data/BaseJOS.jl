export BaseStructure, SlotDefinition, 
    Top, Object, Class, BuiltInClass

mutable struct BaseStructure
    class_of_reference::Any #= Supposed to be another BaseStructure =#
    slots::Dict{Symbol, Any}
end

mutable struct SlotDefinition
    name::Symbol
    initform::Any
end

mutable struct SlotValue
    value::Any
    getter::Any
    setter::Any
end

function Base.hash(one::SlotDefinition)
    return hash(one.name)
end

function Base.:(==)(one::SlotDefinition, another::SlotDefinition)
    return one.name == another.name
end

function Base.:(==)(one::Symbol, another::SlotDefinition)
    return one == another.name
end

function Base.:(==)(one::SlotDefinition, another::Symbol)
    return one.name == another
end

function slot_value_factory(slot_name::Symbol, slot_value)
    return SlotValue(
        slot_value,
        (instance) -> getfield(instance, :slots)[slot_name].value,
        (instance, new_value) -> getfield(instance, :slots)[slot_name].value = new_value
    )
end

Top = BaseStructure(
    nothing,
    Dict(
        :name=>slot_value_factory(:name, :Top),
        :direct_superclasses=>slot_value_factory(:direct_superclasses, []), 
        :direct_slots=>slot_value_factory(:direct_slots, []),
        :class_precedence_list=>slot_value_factory(:class_precedence_list, []),
        :slots=>slot_value_factory(:slots, []),
    )
)

pushfirst!(getfield(Top, :slots)[:class_precedence_list].value, Top)

Object = BaseStructure(
    nothing,
    Dict(
        :name=>slot_value_factory(:name, :Object),
        :direct_superclasses=>slot_value_factory(:direct_superclasses, [Top]), 
        :direct_slots=>slot_value_factory(:direct_slots, []),
        :class_precedence_list=>slot_value_factory(:class_precedence_list, [Top]),
        :slots=>slot_value_factory(:slots, []),
    )
)

pushfirst!(getfield(Object, :slots)[:class_precedence_list].value, Object)

Class = BaseStructure(
    nothing,
    Dict(
        :name => slot_value_factory(:name, :Class),
        :direct_superclasses => slot_value_factory(:direct_superclasses, [Object]), 
        :direct_slots => slot_value_factory(:direct_slots, [
            SlotDefinition(:name, missing),
            SlotDefinition(:direct_superclasses, []), 
            SlotDefinition(:class_precedence_list, []),
            SlotDefinition(:direct_slots, []),
            SlotDefinition(:slots, [])]),
        :class_precedence_list => slot_value_factory(:class_precedence_list, [Object, Top]),
        :slots => slot_value_factory(:slots, [
            SlotDefinition(:name, missing),
            SlotDefinition(:direct_superclasses, []), 
            SlotDefinition(:class_precedence_list, []),
            SlotDefinition(:direct_slots, []),
            SlotDefinition(:slots, [])])
    )
)

pushfirst!(getfield(Class, :slots)[:class_precedence_list].value, Class)

setfield!(Class, :class_of_reference, Class)
setfield!(Object, :class_of_reference, Class)
setfield!(Top, :class_of_reference, Class)

BuiltInClass = BaseStructure(
    Class,
    Dict(
        :name => slot_value_factory(:name, :BuiltInClass),
        :direct_superclasses => slot_value_factory(:direct_superclasses, [Class]), 
        :direct_slots => slot_value_factory(:direct_slots, []),
        :class_precedence_list => slot_value_factory(:class_precedence_list, [Class]),
        :slots => slot_value_factory(:slots, [
            SlotDefinition(:name, missing),
            SlotDefinition(:direct_superclasses, []), 
            SlotDefinition(:class_precedence_list, []),
            SlotDefinition(:direct_slots, []),
            SlotDefinition(:slots, [])])
    )
)

pushfirst!(getfield(BuiltInClass, :slots)[:class_precedence_list].value, BuiltInClass)

function Base.getproperty(obj::BaseStructure, sym::Symbol)
    getfield(obj, :slots)[sym].getter(obj)
end

function Base.setproperty!(obj::BaseStructure, sym::Symbol, value)
    getfield(obj, :slots)[sym].setter(obj, value)
end
