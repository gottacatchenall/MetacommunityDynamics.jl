# Constructors for location
Location(; dimensions::Int=2) = Location(rand(Distributions.Uniform(), dimensions))
Base.ndims(a::Location) = length(a.coordinate)


struct PoissonProcess <: LocationSetGenerator
        numberOfLocations::Int
        dimensions::Int
end
PoissonProcess(; numberOfLocations = 10, dimensions = 2) = PoissonProcess(numberOfLocations, dimensions)
function (gen::PoissonProcess)()
    locations::Vector{Location} = []
    numberOfLocations = gen.numberOfLocations
    # random locations in the unit square
    for p = 1:numberOfLocations
        push!(locations, Location(dimensions=gen.dimensions))
    end

    return(LocationSet(locations))
end


Base.length(a::LocationSet) = length(a.locations)
Base.size(a::LocationSet) = length(a.locations)
Base.isempty(a::LocationSet) = (length(a.locations) == 0)
Base.getindex(a::LocationSet, i::Int64) = a.locations[i]

function Base.iterate(S::LocationSet)
    isempty(S) && return nothing
    return (S.locations[1], 1)
end

function Base.iterate(S::LocationSet, state::Int64)
    next = (state == length(S)) ? nothing : state+1
    isnothing(next) && return nothing
    return (S.locations[state], next)
end
