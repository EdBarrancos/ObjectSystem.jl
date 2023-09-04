export new

@defmethod allocate_instance(class::Class) = begin
    
end

@defmethod initialize(object::Object, initargs) = begin
    
end

@defmethod initialize(class::Class, initargs) = begin
    
end

new(class, initargs...) = begin
    check_for_polymorph(class, Class, ArgumentError)

    instance = allocate_instance(class)
    initialize(instance, initargs)
    return instance
end