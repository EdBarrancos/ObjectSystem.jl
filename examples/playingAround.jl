using JuliaObjectSystem

@defclass(SimpleClass, [], [])

isa(SimpleClass, BaseStructure)
class_of(SimpleClass) === Class
getfield(SimpleClass, :class_of_reference) === Class
SimpleClass.name === :SimpleClass
getfield(SimpleClass, :direct_superclasses) == [Object]
getfield(SimpleClass, :class_precedence_list) == [SimpleClass, Object]
getfield(SimpleClass, :slots) == []
getfield(SimpleClass, :direct_slots) == []