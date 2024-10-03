export _Tuple, _Pairs, _Symbol

_Tuple = BaseStructure(
    BuiltInClass,
    Dict(
        :name => slot_value_factory(:name, :Tuple), 
        :direct_superclasses => slot_value_factory(:direct_superclasses, [Top]), 
        :class_precedence_list => slot_value_factory(:class_precedence_list, [Top]), 
        :direct_slots => slot_value_factory(:direct_slots, []),
        :slots => slot_value_factory(:slots, [])
    )
)

pushfirst!(_Tuple.class_precedence_list, _Tuple)
class_of(type::Tuple) = _Tuple

_Pairs = BaseStructure(
    BuiltInClass,
    Dict(
        :name => slot_value_factory(:name, :Pairs), 
        :direct_superclasses => slot_value_factory(:direct_superclasses, [Top]), 
        :class_precedence_list => slot_value_factory(:class_precedence_list, [Top]), 
        :direct_slots => slot_value_factory(:direct_slots, []),
        :slots => slot_value_factory(:slots, [])
    )
)

pushfirst!(_Pairs.class_precedence_list, _Pairs)
class_of(type::Base.Pairs) = _Pairs

_Symbol = BaseStructure(
    BuiltInClass,
    Dict(
        :name => slot_value_factory(:name, :Symbol), 
        :direct_superclasses => slot_value_factory(:direct_superclasses, [Top]), 
        :class_precedence_list => slot_value_factory(:class_precedence_list, [Top]), 
        :direct_slots => slot_value_factory(:direct_slots, []),
        :slots => slot_value_factory(:slots, [])
    )
)

pushfirst!(_Symbol.class_precedence_list, _Symbol)
class_of(type::Symbol) = _Symbol