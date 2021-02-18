module Landscapes
    using ..MetacommunityDynamics
    using Distributions
    using Base


    #=
        Location()
        ----------------------------------------------------
        A population, associated with a coordinate.
    =#
    mutable struct Location
       coordinate::Vector{Float64}
    end
    distance(L1::Location, L2::Location) = sqrt(sum( (L1.coordinate - L2.coordinate).^2 ))

    export Location, distance


    #=
        LocationSet()
        ----------------------------------------------------
        A set of populations.
    =#
    mutable struct LocationSet
        locations::Vector{Location}
    end
    Base.size(l::LocationSet) = length(l.locations)
    LocationSet(; numberOfLocations = 5, dimensions = 2) = PoissonProcess(; numberOfLocations = numberOfLocations, dimensions = dimensions)()


    export LocationSet

    #=
        abstract type declaration
    =#
    abstract type EnvironmentalVariable end

    abstract type LandscapeGenerator end
    abstract type LocationSetGenerator end
    abstract type EnvironmentGenerator end



    include(joinpath(".", "generators.jl"))

    struct Landscape
        locations::LocationSet
    end
    Landscape(; locations = LocationSet()) = Landscape(locations)
    Base.size(l::Landscape) = size(l.locations)

    export Landscape

end
