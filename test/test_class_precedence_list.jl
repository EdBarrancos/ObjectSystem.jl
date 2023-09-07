using JuliaObjectSystem
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