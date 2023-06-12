
# Question: how to best incoporate environment?
# Should spatial graph keep a matrix? probably easiest way

struct SpatialGraph{T} 
    coordinates::Vector{Tuple{T,T}} 
    environment::Matrix{T} 
end


Base.size(sg::SpatialGraph) = numsites(sg)
envdims(sg::SpatialGraph) = size(environment(sg), 1)
numsites(sg::SpatialGraph) = length(coordinates(sg))

environment(sg::SpatialGraph) = sg.environment
coordinates(sg::SpatialGraph) = sg.coordinates


"""
    distance_matrix(sg::SpatialGraph; distance = Euclidean())
    
Returns a matrix of pairwise distances for all nodes in a `SpatialGraph` 
"""
function distance_matrix(sg::SpatialGraph; distance = Euclidean())
    distmat = zeros(numsites(sg), numsites(sg))

    for i = 1:numsites(sg), j = 1:numsites(sg)
        x, y = sg.coordinates[i], sg.coordinates[j]
        distmat[i, j] = evaluate(distance, (x[1], x[2]), (y[1], y[2]))
    end
    distmat
end


# 
# Constructors
# 
# 

function SpatialGraph(; coordinates = nothing, environment::Matrix = nothing) 
    _, nsite = size(environment)
    coordinates = isnothing(coordinates) ? 
        (isnothing(environment) ? [(rand(), rand()) for _ = 1:20] : [(rand(), rand()) for _ in 1:nsite]) : coordinates
    environment = isnothing(environment) ?  hcat([rand(5) for _ in eachindex(coordinates)]...) : environment
    SpatialGraph(coordinates, environment)
end

function SpatialGraph(n::Integer) 
    n <= 1 && throw(ArgumentError, "Number of nodes in spatial graph must be > 1")
    SpatialGraph([(rand(), rand()) for _ = 1:n], hcat([rand(5) for _ in 1:n]...))
end

function SpatialGraph(env::Matrix)
    SpatialGraph([(rand(), rand()) for _ in 1:size(env,2)], env)
end

function SpatialGraph(coords::Vector{T}; num_envdims=5) where T<:Tuple
    SpatialGraph(coords, rand(num_envdims, length(coords)))
end



# ====================================================
#
#   Printing
#
# =====================================================

Base.string(sg::SpatialGraph) = """
An {green}{bold}spatial graph{/bold}{/green} with {bold}{blue}$(length(sg.coordinates)){/blue}{/bold} locations.
"""

Base.show(io::IO, ::MIME"text/plain", sg::SpatialGraph) = begin 
    tprint(io, string(sg))
    print(io, 
        scatterplot(
            [x[1] for x in sg.coordinates],
            [x[2] for x in sg.coordinates],
            xlim = (0, 1),
            ylim = (0, 1),
            padding=0,
            marker=:circle
        )
    )
end 


# ====================================================
#
#   Tests
#
# =====================================================

@testitem "We can create a spatial graph with number of nodes as input" begin
    sg = SpatialGraph(7)
    @test numsites(sg) == 7

    @test_throws ArgumentError SpatialGraph(0) 
end

@testitem "We can create a spatial graph with environment matrix as input" begin
    sg = SpatialGraph(rand(5,10))
    @test numsites(sg) == 10
    @test envdims(sg) == 5

    sg = SpatialGraph(environment=rand(3,12))
    @test numsites(sg) == 12
    @test envdims(sg) == 3
end

@testitem "We can create a spatial graph with coordinates as input" begin
    c = [(rand(), rand()) for i in 1:15]
    m = rand(7, length(c))

    # positional 
    sg = SpatialGraph(c, m)
    @test coordinates(sg) == c
    @test environment(sg) == m

    # kwargs
    sg = SpatialGraph(;coordinates=c, environment=m)
    @test coordinates(sg) == c
    @test environment(sg) == m
end

@testitem "We can create a spatial graph with environmental layers as input" begin
    using NeutralLandscapes
    layers = [rand(MidpointDisplacement(0.5), (50,50)) for i in 1:7]
    

end
