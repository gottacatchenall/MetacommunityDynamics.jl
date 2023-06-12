
"""
    EnvironmentLayer{T}

An `EnvironmentalLayer` stores a raster representation of a single environmental
variable inside a matrix.
"""
struct EnvironmentLayer{T}
    matrix::Matrix{T}
end

"""
    EnvironmentLayer(; generator = MidpointDisplacement(0.7), sz=(50,50))

Builds an `EnvironmentalLayer` with a `NeutralLandscapes` generator
"""
function EnvironmentLayer(; generator = MidpointDisplacement(0.7), sz=(50,50))
    EnvironmentLayer(NeutralLandscapes.rand(generator, sz))
end

Base.getindex(el::EnvironmentLayer, x) = el.matrix[x]
Base.getindex(el::EnvironmentLayer, x,y) = el.matrix[x,y]
Base.size(el::EnvironmentLayer) = size(el.matrix)

# ====================================================
#
#   Printing
#
# =====================================================


Base.string(env::EnvironmentLayer) = """
An {green}{bold}environmental layer{/bold}{/green} of size $(size(env.matrix)).
"""

Base.show(io::IO, ::MIME"text/plain", env::EnvironmentLayer) = begin 
    tprint(io, string(env))
    print(io, 
        heatmap(
            env.matrix,
            xlabel="x",
            ylabel="y",
            zlabel="value",
            width=40
        ),
    )
end 


# ====================================================
#
#   Tests
#
# =====================================================

@testitem "We can create an environment layer" begin
    el = EnvironmentLayer()
    @test typeof(el) <: EnvironmentLayer
end

@testitem "We can create an environment layer with different generators" begin
    using NeutralLandscapes
    el = EnvironmentLayer(generator=PerlinNoise((3,3)))
    @test typeof(el) <: EnvironmentLayer

    el = EnvironmentLayer(generator=PlanarGradient())
    @test typeof(el) <: EnvironmentLayer
end

@testitem "We can measure the size of an environmental layer" begin
    el = EnvironmentLayer()
    @test size(el) == (50,50)

    el = EnvironmentLayer(sz=(250,34))
    @test size(el) == (250,34)
end

@testitem "We can get elements of the enviornmental layer" begin
    el = EnvironmentLayer()
    @test typeof(el[3,5]) <: Number
    @test typeof(el[CartesianIndex(3,5)]) <: Number
end