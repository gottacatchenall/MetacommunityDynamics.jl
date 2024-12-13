
"""
    Coordinates{T <: Number}

A `Coordinates` consists of a set of nodes with coordinates and associated environmental
variables for each site.  
"""
struct Coordinates{F<:Real, P, S<:Union{String,Symbol}} <: Spatialness
    coordinates::Vector{Tuple{F,F}} 
    environment::Dict{S,Vector{P}} 
end


"""
    Base.size(coords::Coordinates)

Returns the number of nodes in a coordinate set `coords`.
"""
Base.size(coords::Coordinates) = numsites(coords)


"""
    envdims(coords::Coordinates)

Returns the dimensionality of the environmental variable associated with each
node in a `Coordinates` coords.
"""
envdims(coords::Coordinates) = length(values(environment(coords)))

"""
    numsites(coords::Coordinates)

Returns the number of nodes in a `Coordinates` `coords`. 
"""
numsites(coords::Coordinates) = length(coordinates(coords))

"""
    environment(coords::Coordinates)

Returns the dictionary of environmental variables of a `Coordinates` `coords`
"""
environment(coords::Coordinates) = coords.environment

environment(coords::Coordinates, i) = Dict(zip(keys(environment(coords)), [v[i] for v in values(environment(coords))]))

coordinates(coords::Coordinates) = coords.coordinates


"""
    distance_matrix(coords::Coordinates; distance = Euclidean())
    
Returns a matrix of pairwise distances for all nodes in a `Coordinates`. The argument passed to `distance` must be of type `Distance` from `Distances.jl`.
"""
function distance_matrix(coords::Coordinates; distance = Euclidean())
    distmat = zeros(numsites(coords), numsites(coords))

    for i = 1:numsites(coords), j = 1:numsites(coords)
        x, y = coords.coordinates[i], coords.coordinates[j]
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
    Coordinates(layers::Vector{E}; coords = [(rand(), rand()) for _ = 1:20]) where E<:EnvironmentLayer

Builds a coordinate set with environmental variables passed as a vector of
EnvironmentLayers, and optionally coordinates passed as a keyword argument. 
"""
function Coordinates(layers::Vector{E}; coords = [(rand(), rand()) for _ = 1:20]) where E<:EnvironmentLayer
    Coordinates(coords, Dict([Symbol("l$i") => _env_from_layer(coords, l) for (i,l) in enumerate(layers)]))
end

"""
    Coordinates(layer::E; coords = [(rand(), rand()) for _ = 1:20]) where E<:EnvironmentLayer

Builds a `Coordinates` where the environmental variable is built from a single
EnvironmentLayer, and optionally the set of coordinates can be passed as a
keyword argument.
"""
function Coordinates(layer::E; coords = [(rand(), rand()) for _ = 1:20]) where E<:EnvironmentLayer
    Coordinates(coords, Dict(:x=>_env_from_layer(coords, layer)))
end

"""
    Coordinates(; coords = nothing, env = nothing)  

Builds a `Coordinates`, where both the coordinates and the environmental
variables can be passed as keyword arguments. The environment should
be a dictionary where (key,value) pairs are names of each environmnetal variable
and vectors of that variable across each node in the `Coordinates`.
"""
function Coordinates(; coords = nothing, env = nothing)  
    if isnothing(coords) && isnothing(env)
        c = [(rand(), rand()) for _ = 1:20]
        e = Dict(:e1 => rand(length(c)))
        return Coordinates(c, e)
    else
        coords = isnothing(coords) ? 
            (isnothing(env) ? [(rand(), rand()) for _ = 1:20] : [(rand(), rand()) for _ in 1:length(first(values(env)))]) : coords
            env = isnothing(env) ?  Dict(:e1 => rand(length(c))) : env
        !allequal([length(v) for v in values(env)]) && throw(ArgumentError, "Not all environmental variables match in size.")
        return Coordinates(coords, env)
    end 
end

"""
    Coordinates(n::Integer) 

Builds a coordinate set with `n` nodes in it.
"""
function Coordinates(n::Integer) 
    n <= 1 && throw(ArgumentError, "Number of nodes in coordinate set must be > 1")
    Coordinates([(rand(), rand()) for _ = 1:n], Dict([:e => rand(n)]))
end

"""
    Coordinates(env::Dict{S,Vector}) 

Builds a coordinate set for a given environment matrix. The environmental matrix should
be a matrix where each column is the vector of environmental variables for each node.
"""
function Coordinates(env::Dict{S,Vector{T}}) where {S<:Union{String,Symbol},T}
    Coordinates([(rand(), rand()) for _ in 1:length(first(values(env)))], env)
end

"""
    Coordinates(coords::Vector{T}) where T<:Tuple

Constructs a `Coordinates` from a set of coordinates `coords`, which is a
vector of (x,y) pairs. Builds a random environment variable named :x.
"""
function Coordinates(coords::Vector{T}) where T<:Tuple
    Coordinates(coords, Dict(:x=>rand(length(coords))))
end

function Coordinates(;num_sites=30, env_dims=4, env_dist = MvNormal(ones(env_dims)))
    coords = [(rand(), rand()) for _ = 1:num_sites]
    env = Dict(:env => [rand(env_dist) for c in coords])
    Coordinates(coords, env)
end


# ====================================================
#
#   Printing
#
# =====================================================

Base.string(coords::Coordinates) = """
A {green}{bold}Coorindate{/bold}{/green} set with {bold}{blue}$(length(coords.coordinates)){/blue}{/bold} sites.

Environment: $(environment(coords))
"""

Base.show(io::IO, ::MIME"text/plain", coords::Coordinates) = begin 
    i = [coordinates(coords)[idx][1] for idx in eachindex(coordinates(coords))]
    j = [coordinates(coords)[idx][1] for idx in eachindex(coordinates(coords))]
    plt = scatterplot(
        [x[1] for x in coords.coordinates],
        [x[2] for x in coords.coordinates],
        xlim = (0, 1),
        ylim = (0, 1),
        padding=0,
        marker=:circle
    );
    tprint(io, string(coords))
    print(io, 
        plt
    )
end 


# ====================================================
#
#   Tests
#
# =====================================================

@testitem "We can create a coordinate set" begin
    coords = Coordinates()
    @test typeof(coords) <: Coordinates
end

@testitem "We can create a coordinate set with number of nodes as input" begin
    coords = Coordinates(7)
    @test numsites(coords) == 7

    @test_throws ArgumentError Coordinates(0) 
end

@testitem "We can create a coordinate set with environment dictionary as input" begin
    coords = Coordinates(Dict(:x=>rand(10)))
    @test numsites(coords) == 10
    @test envdims(coords) == 1

    coords = Coordinates(env=Dict(:x1=>rand(12), :x2=>rand(12)))
    @test numsites(coords) == 12
    @test envdims(coords) == 2

    @test_throws ArgumentError Coordinates(env=Dict(:x1=>rand(10), :x2=>rand(5)))
end

@testitem "We can create a coordinate set with coordinates as input" begin
    c = [(rand(), rand()) for i in 1:15]
    m = Dict([Symbol("x$i")=>rand(7) for i in 1:20])

    # positional 
    coords = Coordinates(c, m)
    @test coordinates(coords) == c
    @test environment(coords) == m

    # kwargs
    coords = Coordinates(;coords=c, env=m)
    @test coordinates(coords) == c
    @test environment(coords) == m
end

@testitem "We can create a coordinate set with environment layer as input" begin
    el = EnvironmentLayer()
    coords = Coordinates(el)
    @test typeof(coords) <: Coordinates

    c = [(rand(), rand()) for i in 1:15]
    coords = Coordinates(el; coords=c)
    @test coordinates(coords) == c
end


@testitem "We can create a coordinate set with many environment layers as input" begin
    layers = [EnvironmentLayer() for i in 1:7]
    coords = Coordinates(layers)
    @test typeof(coords) <: Coordinates
    @test envdims(coords) == 7

    c = [(rand(), rand()) for i in 1:15]
    coords = Coordinates(layers; coords=c)
    @test coordinates(coords) == c
    @test numsites(coords) == 15
end
