

struct EnvironmentLayer{T}
    matrix::Matrix{T}
end

function EnvironmentLayer(; generator = MidpointDisplacement(0.7), sz=(50,50))
    EnvironmentLayer(rand(generator, sz))
end


Base.getindex(el::EnvironmentLayer, x) = el.matrix[x]
Base.getindex(el::EnvironmentLayer, x,y) = el.matrix[x,y]
Base.size(el::EnvironmentLayer) = size(el.matrix)

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