
"""
    SpatialGraph{T <: Number}

A `SpatialGraph` consists of a set of nodes with coordinates and associated environmental
variables for each node.

Specific information about the edges in a `SpatialGraph` (which represent
movement between nodes) is not stored here, as they tend to rely on
species-specific parameters. As such, that are computed by combining a
`SpatialGraph` with a  `DispersalKernel` to create a `DispersalPotential`.  
"""
struct SpatialGraph{T <: Number} 
    coordinates::Vector{Tuple{T,T}} 
    environment::Matrix{T} 
end


"""
    Base.size(sg::SpatialGraph)

Returns the number of nodes in a spatial graph `sg`.
"""
Base.size(sg::SpatialGraph) = numsites(sg)


"""
    envdims(sg::SpatialGraph)

Returns the dimensionality of the environmental variable associated with each
node in a `SpatialGraph` sg.
"""
envdims(sg::SpatialGraph) = size(environment(sg), 1)

"""
    numsites(sg::SpatialGraph)

Returns the number of nodes in a `SpatialGraph` `sg`. 
"""
numsites(sg::SpatialGraph) = length(coordinates(sg))

"""
    environment(sg::SpatialGraph)

Returns the matrix of environmental variables of a `SpatialGraph` `sg`
"""
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


# ====================================================
#
#   Constructors
#
# =====================================================

"""
    _env_from_layer(coords, layer::EnvironmentLayer)

Returns the values in the layer at the given coordinates, given the bounding-box
os the coordinates is the extent of the layer.
"""
function _env_from_layer(coords, layer::EnvironmentLayer)
    x,y = size(layer)
    I = [CartesianIndex(Int32(floor(c[1]*x+1)), Int32(floor(c[2]*y+1))) for c in coords]
    return layer[I]
end 

"""
    SpatialGraph(layers::Vector{E}; coords = [(rand(), rand()) for _ = 1:20]) where E<:EnvironmentLayer

Builds a spatial graph with environmental variables passed as a vector of
EnvironmentLayers, and optionally coordinates passed as a keyword argument. 
"""
function SpatialGraph(layers::Vector{E}; coords = [(rand(), rand()) for _ = 1:20]) where E<:EnvironmentLayer
    SpatialGraph(coords, Matrix(hcat([_env_from_layer(coords, l) for l in layers]...)')) 
end

"""
    SpatialGraph(layer::E; coords = [(rand(), rand()) for _ = 1:20]) where E<:EnvironmentLayer

Builds a `SpatialGraph` where the environmental variable is built from a single
EnvironmentLayer, and optionally the set of coordinates can be passed as a
keyword argument.
"""
function SpatialGraph(layer::E; coords = [(rand(), rand()) for _ = 1:20]) where E<:EnvironmentLayer
    SpatialGraph(coords, Matrix(_env_from_layer(coords, layer)'))
end

"""
    SpatialGraph(; coords = nothing, env = nothing)  

Builds a `SpatialGraph`, where both the coordinates and the environmental
variables can be passed as keyword arguments. The environmental matrix should
be a matrix where each column is the vector of environmental variables for each node.
"""
function SpatialGraph(; coords = nothing, env = nothing)  
    if isnothing(coords) && isnothing(env)
        c = [(rand(), rand()) for _ = 1:20]
        e = hcat([rand(5) for _ in 1:length(c)]...)
        return SpatialGraph(c, e)
    else
        coords = isnothing(coords) ? 
            (isnothing(env) ? [(rand(), rand()) for _ = 1:20] : [(rand(), rand()) for _ in 1:size(env,2)]) : coords
            env = isnothing(env) ?  hcat([rand(5) for _ in eachindex(coords)]...) : env
        return SpatialGraph(coords, env)
    end 
end

"""
    SpatialGraph(n::Integer) 

Builds a spatial graph with `n` nodes in it.
"""
function SpatialGraph(n::Integer) 
    n <= 1 && throw(ArgumentError, "Number of nodes in spatial graph must be > 1")
    SpatialGraph([(rand(), rand()) for _ = 1:n], hcat([rand(5) for _ in 1:n]...))
end

"""
    SpatialGraph(n::Integer) 

Builds a spatial graph for a given environment matrix. The environmental matrix should
be a matrix where each column is the vector of environmental variables for each node.
"""
function SpatialGraph(env::Matrix)
    SpatialGraph([(rand(), rand()) for _ in 1:size(env,2)], env)
end

"""
    SpatialGraph(coords::Vector{T}; num_envdims=5) where T<:Tuple

Constructs a `SpatialGraph` from a set of coordinates `coords`, which is a
vector of (x,y) pairs. Builds a random environment matrix, with the optional
keyword argument `num_envdims` controlling the dimensionality of the
envrionmental variables at each node. 
"""
function SpatialGraph(coords::Vector{T}; num_envdims=5) where T<:Tuple
    SpatialGraph(coords, rand(num_envdims, length(coords)))
end



# ====================================================
#
#   Printing
#
# =====================================================

Base.string(sg::SpatialGraph) = """
A {green}{bold}spatial graph{/bold}{/green} with {bold}{blue}$(length(sg.coordinates)){/blue}{/bold} locations.
"""

Base.show(io::IO, ::MIME"text/plain", sg::SpatialGraph) = begin 
    i = [coordinates(sg)[idx][1] for idx in eachindex(coordinates(sg))]
    j = [coordinates(sg)[idx][1] for idx in eachindex(coordinates(sg))]

    plt = scatterplot(
        [x[1] for x in sg.coordinates],
        [x[2] for x in sg.coordinates],
        xlim = (0, 1),
        ylim = (0, 1),
        padding=0,
        marker=:circle
    );
    tprint(io, string(sg))
    print(io, 
        plt
    )
end 


# ====================================================
#
#   Tests
#
# =====================================================

@testitem "We can create a spatial graph" begin
    sg = SpatialGraph()
    @test typeof(sg) <: SpatialGraph
end

@testitem "We can create a spatial graph with number of nodes as input" begin
    sg = SpatialGraph(7)
    @test numsites(sg) == 7

    @test_throws ArgumentError SpatialGraph(0) 
end

@testitem "We can create a spatial graph with environment matrix as input" begin
    sg = SpatialGraph(rand(5,10))
    @test numsites(sg) == 10
    @test envdims(sg) == 5

    sg = SpatialGraph(env=rand(3,12))
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
    sg = SpatialGraph(;coords=c, env=m)
    @test coordinates(sg) == c
    @test environment(sg) == m
end

@testitem "We can create a spatial graph with environment layer as input" begin
    el = EnvironmentLayer()
    sg = SpatialGraph(el)
    @test typeof(sg) <: SpatialGraph

    c = [(rand(), rand()) for i in 1:15]
    sg = SpatialGraph(el; coords=c)
    @test coordinates(sg) == c
end


@testitem "We can create a spatial graph with many environment layers as input" begin
    layers = [EnvironmentLayer() for i in 1:7]
    sg = SpatialGraph(layers)
    @test typeof(sg) <: SpatialGraph
    @test envdims(sg) == 7

    c = [(rand(), rand()) for i in 1:15]
    sg = SpatialGraph(layers; coords=c)
    @test coordinates(sg) == c
    @test numsites(sg) == 15
end