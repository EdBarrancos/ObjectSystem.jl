export _Exception, _TypeException, _IO,
    _Vector, _Pair, _NamedTuple,
    _Int8, _Int16, _Int32, _Int64, _Int128, _Int,
    _Bool, _Char, _String,
    _Float16, _Float32, _Float64

@defbuiltin _Exception(Exception)
@defbuiltin _TypeException(Type{Exception})
@defbuiltin _IO(IO)

@defbuiltin _Int8(Int8)
@defbuiltin _Int16(Int16)
@defbuiltin _Int32(Int32)
@defbuiltin _Int64(Int64)
@defbuiltin _Int128(Int128)

@defbuiltin _Int(Int)

@defbuiltin _Bool(Bool)

@defbuiltin _Char(Char)
@defbuiltin _String(String)

@defbuiltin _Float16(Float16)
@defbuiltin _Float32(Float32)
@defbuiltin _Float64(Float64)

@defbuiltin _Vector(Vector)
@defbuiltin _Pair(Pair)
@defbuiltin _NamedTuple(NamedTuple)