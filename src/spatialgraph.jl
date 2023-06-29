
"""
    SpatialGraph{T <: Number}

A `SpatialGraph` consists of a set of nodes with coordinates and associated environmental
variables for each node.

Specific information about the edges in a `SpatialGraph` (which represent
movement between nodes) is not stored here, as they tend to rely on
species-specific parameters. As such, that are computed by combining a
`SpatialGraph` with a  `DispersalKernel` to create a `DispersalPotential`.  
"""
struct SpatialGraph{T <: Number, S<:Union{String,Symbol}} <: Spatialness
    coordinates::Vector{Tuple{T,T}} 
    environment::Dict{S,Vector{T}} 
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
envdims(sg::SpatialGraph) = length(values(environment(sg)))

"""
    numsites(sg::SpatialGraph)

Returns the number of nodes in a `SpatialGraph` `sg`. 
"""
numsites(sg::SpatialGraph) = length(coordinates(sg))

"""
    environment(sg::SpatialGraph)

Returns the dictionary of environmental variables of a `SpatialGraph` `sg`
"""
environment(sg::SpatialGraph) = sg.environment

environment(sg::SpatialGraph, i) = Dict(zip(keys(environment(sg)), [v[i] for v in values(environment(sg))]))

coordinates(sg::SpatialGraph) = sg.coordinates


"""
    distance_matrix(sg::SpatialGraph; distance = Euclidean())
    
Returns a matrix of pairwise distances for all nodes in a `SpatialGraph`. The argument passed to `distance` must be of type `Distance` from `Distances.jl`.
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
    SpatialGraph(coords, Dict([Symbol("l$i") => _env_from_layer(coords, l) for (i,l) in enumerate(layers)]))
end

"""
    SpatialGraph(layer::E; coords = [(rand(), rand()) for _ = 1:20]) where E<:EnvironmentLayer

Builds a `SpatialGraph` where the environmental variable is built from a single
EnvironmentLayer, and optionally the set of coordinates can be passed as a
keyword argument.
"""
function SpatialGraph(layer::E; coords = [(rand(), rand()) for _ = 1:20]) where E<:EnvironmentLayer
    SpatialGraph(coords, Dict(:x=>_env_from_layer(coords, layer)))
end

"""
    SpatialGraph(; coords = nothing, env = nothing)  

Builds a `SpatialGraph`, where both the coordinates and the environmental
variables can be passed as keyword arguments. The environment should
be a dictionary where (key,value) pairs are names of each environmnetal variable
and vectors of that variable across each node in the `SpatialGraph`.
"""
function SpatialGraph(; coords = nothing, env = nothing)  
    if isnothing(coords) && isnothing(env)
        c = [(rand(), rand()) for _ = 1:20]
        e = Dict(:e1 => rand(length(c)))
        return SpatialGraph(c, e)
    else
        coords = isnothing(coords) ? 
            (isnothing(env) ? [(rand(), rand()) for _ = 1:20] : [(rand(), rand()) for _ in 1:length(first(values(env)))]) : coords
            env = isnothing(env) ?  Dict(:e1 => rand(length(c))) : env
        !allequal([length(v) for v in values(env)]) && throw(ArgumentError, "Not all environmental variables match in size.")
        return SpatialGraph(coords, env)
    end 
end

"""
    SpatialGraph(n::Integer) 

Builds a spatial graph with `n` nodes in it.
"""
function SpatialGraph(n::Integer) 
    n <= 1 && throw(ArgumentError, "Number of nodes in spatial graph must be > 1")
    SpatialGraph([(rand(), rand()) for _ = 1:n], Dict([Symbol("e1") => rand(n)]))
end

"""
    SpatialGraph(env::Dict{S,Vector}) 

Builds a spatial graph for a given environment matrix. The environmental matrix should
be a matrix where each column is the vector of environmental variables for each node.
"""
function SpatialGraph(env::Dict{S,Vector{T}}) where {S<:Union{String,Symbol},T}
    SpatialGraph([(rand(), rand()) for _ in 1:length(first(values(env)))], env)
end

"""
    SpatialGraph(coords::Vector{T}) where T<:Tuple

Constructs a `SpatialGraph` from a set of coordinates `coords`, which is a
vector of (x,y) pairs. Builds a random environment variable named :x.
"""
function SpatialGraph(coords::Vector{T}) where T<:Tuple
    SpatialGraph(coords, Dict(:x=>rand(length(coords))))
end



# ====================================================
#
#   Printing
#
# =====================================================

Base.string(sg::SpatialGraph) = """
A {green}{bold}spatial graph{/bold}{/green} with {bold}{blue}$(length(sg.coordinates)){/blue}{/bold} locations.

Environment: $(environment(sg))
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

@testitem "We can create a spatial graph with environment dictionary as input" begin
    sg = SpatialGraph(Dict(:x=>rand(10)))
    @test numsites(sg) == 10
    @test envdims(sg) == 1

    sg = SpatialGraph(env=Dict(:x1=>rand(12), :x2=>rand(12)))
    @test numsites(sg) == 12
    @test envdims(sg) == 2

    @test_throws ArgumentError SpatialGraph(env=Dict(:x1=>rand(10), :x2=>rand(5)))
end

@testitem "We can create a spatial graph with coordinates as input" begin
    c = [(rand(), rand()) for i in 1:15]
    m = Dict([Symbol("x$i")=>rand(7) for i in 1:20])

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
