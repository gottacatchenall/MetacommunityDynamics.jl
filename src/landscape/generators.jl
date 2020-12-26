# Constructors for location
Location(; dimensions::Int=2) = Location(rand(Distributions.Uniform(), dimensions))
Base.ndims(a::Location) = length(a.coordinate)

struct PoissonProcess <: LocationSetGenerator
        number_of_locations::Int
        dimensions::Int
end
PoissonProcess(; number_of_locations = 10, dimensions = 2) = PoissonProcess(number_of_locations, dimensions)
function (gen::PoissonProcess)()
    locations::Vector{Location} = []
    number_of_locations = gen.number_of_locations
    # random locations in the unit square
    for p = 1:number_of_locations
        push!(locations, Location(dimensions=gen.dimensions))
    end

    return(LocationSet(locations))
end

LocationSet(; number_of_locations = 20, dimensions = 2) = PoissonProcess(; number_of_locations = number_of_locations, dimensions = dimensions)()

Base.length(a::LocationSet) = length(a.locations)
Base.size(a::LocationSet) = length(a.locations)
Base.isempty(a::LocationSet) = (length(a.locations) == 0)


function Base.iterate(S::LocationSet)
    isempty(S) && return nothing
    return (S.locations[1], 1)
end

function Base.iterate(S::LocationSet, state::Int64)
    next = (state == length(S)) ? nothing : state+1
    isnothing(next) && return nothing
    return (S.locations[state], next)
end
