export print_object

@defgeneric print_object(object, io)

@defmethod print_object(class::Class, io::_IO) = begin
    print(io, 
        "<" ,
        String(getfield(class, :class_of_reference).name), 
        " ", 
        String(class.name), 
        ">")
end

@defmethod print_object(obj::Object, io::_IO) = begin
    print(io, 
        "<",
        String(getfield(obj, :class_of_reference).name),
        " ", 
        repr(UInt64(pointer_from_objref(obj))), 
        ">")
end

@defmethod print_object(generic_func::GenericFunction, io::_IO) = begin
    print(io,
        "<", 
        String(getfield(generic_func, :class_of_reference).name), 
        " ", 
        generic_func.name, 
        " with ", 
        length(generic_func.methods),
        " methods>")
end

@defmethod print_object(method::MultiMethod, io::_IO) = begin
    print(io,
        "<",
        String(class_of(method).name),
        " ",
        String(method.generic_function.name))
    
    print(io, "(")
    if length(method.specializers) > 0
        print(io, method.specializers[begin].name)
    end

    for elem in method.specializers[2:end]
        print(io, ", ")
        print(io, elem.name)
    end

    print(io, ")", ">")
end

@defmethod print_object(vector::_Vector, io::_IO) = begin
    print(io, "[")
    if length(vector) > 0
        print(io, vector[begin])
    end

    for elem in vector[2:end]
        print(io, ", ")
        print(io, elem)
    end

    print(io, "]")
end

@defmethod print_object(tuple::_Tuple, io::_IO) = begin
    print(io, "(")
    if length(tuple) > 0
        print(io, tuple[begin])
    end

    for elem in tuple[2:end]
        print(io, ", ")
        print(io, elem)
    end

    print(io, ")")
end

function Base.show(io::IO, ::MIME"text/plain", t::Union{BaseStructure, Vector, Tuple})
    print_object(t, io)
end

function Base.show(io::IO, t::Union{BaseStructure, Vector, Tuple})
    print_object(t, io)
end

function Base.show(io::IO, ::MIME"text/plain", t::Union{SlotDefinition})
    print(io, t.name)
end

function Base.show(io::IO, t::Union{SlotDefinition})
    print(io, t.name)
end
