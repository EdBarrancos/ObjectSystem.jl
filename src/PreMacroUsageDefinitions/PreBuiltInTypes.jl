export _Tuple, _Pairs

_Tuple = BaseStructure(
    BuiltInClass,
    Dict(
        :name => :Tuple, 
        :direct_superclasses => [Top], 
        :class_precedence_list => [Top], 
        :slots => []
    )
)

pushfirst!(getfield(_Tuple, :slots)[:class_precedence_list], _Tuple)
class_of(type::Tuple) = _Tuple

_Pairs = BaseStructure(
    BuiltInClass,
    Dict(
        :name => :Pairs, 
        :direct_superclasses => [Top], 
        :class_precedence_list => [Top], 
        :slots => []
    )
)

pushfirst!(getfield(_Pairs, :slots)[:class_precedence_list], _Pairs)
class_of(type::Base.Pairs) = _Pairs