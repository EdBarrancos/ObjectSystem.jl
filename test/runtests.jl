using ObjectSystem
using Test

macro capture_out(block)
    quote
        if ccall(:jl_generating_output, Cint, ()) == 0
            original_stdout = stdout
            out_rd, out_wr = redirect_stdout()
            out_reader = @async read(out_rd, String)
        end

        try
            $(esc(block))
        finally
            if ccall(:jl_generating_output, Cint, ()) == 0
                redirect_stdout(original_stdout)
                close(out_wr)
            end
        end

        if ccall(:jl_generating_output, Cint, ()) == 0
            fetch(out_reader)
        else
            ""
        end
    end
end

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
    include("test_instantiation_protocol.jl")
    include("test_device_shape.jl")
    include("test_slot_access_protocol.jl")
    include("test_multiple_meta_class_inheritance.jl")
end