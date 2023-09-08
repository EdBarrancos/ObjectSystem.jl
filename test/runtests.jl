using JuliaObjectSystem
using Test

@testset "All Tests" begin
    include("test_baseJOS.jl")
    include("test_defclass.jl")
    include("test_generic_methods.jl")
    include("test_defmacros_functions.jl")
    include("test_complex_number.jl")
    include("test_compute_slots.jl")
    include("test_class_precedence_list.jl")
    include("test_built_in_classes.jl")
    include("test_person.jl")
    inlcude("test_instantiation_protocol.jl")
end