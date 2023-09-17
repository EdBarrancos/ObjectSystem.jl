using ObjectSystem
using Test

@testset "Class Precedence List" begin
    @defclass(A, [], [])
    @defclass(B, [], [])
    @defclass(C, [], [])
    @defclass(D, [A, B], [])
    @defclass(E, [A, C], [])
    @defclass(F, [D, E], [])

    @test compute_cpl(F) == [F, D, E, A, B, C, Object, Top]
end

@defclass(FlavorsClass, [Class], [])

@defmethod compute_cpl(class::FlavorsClass) = begin
    depth_first_cpl(class) = 
        [class, foldl(vcat, map(depth_first_cpl, class_direct_superclasses(class)), init=[])...]
    base_cpl = [Object, Top]

    return vcat(unique(filter(!in(base_cpl), depth_first_cpl(class))), base_cpl)
end

@defclass(A, [], [], metaclass=FlavorsClass)
@defclass(B, [], [], metaclass=FlavorsClass)
@defclass(C, [], [], metaclass=FlavorsClass)
@defclass(D, [A, B], [], metaclass=FlavorsClass)
@defclass(E, [A, C], [], metaclass=FlavorsClass)
@defclass(F, [D, E], [], metaclass=FlavorsClass)

@test compute_cpl(F) == [F, D, A, B, E, C, Object, Top]