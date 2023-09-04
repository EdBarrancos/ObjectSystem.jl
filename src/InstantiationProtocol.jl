export new, allocate_instance, initialize

@defmethod allocate_instance(class::Class) = begin
    return BaseStructure(
        class,
        Dict()
    )
end

@defmethod initialize(object::Object, initargs) = begin
    class_slots = getfield(class_of(object), :slots)
    for slot in class_slots
        target_value = slot.initform
        if haskey(initargs, slot.name)
            target_value = initargs[slot.name]
        end

        getfield(object, :slots)[slot.name] = target_value
    end
end

@defmethod initialize(class::Class, initargs) = begin
    class_slots = class_of(class).slots
    for slot in class_slots
        target_value =slot.initform
        if haskey(initargs, slot.name)
            target_value = initargs[slot.name]
        end

        getfield(class, :slots)[slot.name] = target_value
    end
end

new(class; initargs...) = begin
    check_for_polymorph(class, Class, ArgumentError)

    instance = allocate_instance(class)
    initialize(instance, initargs)
    return instance
end