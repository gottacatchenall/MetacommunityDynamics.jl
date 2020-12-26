module Landscape
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

    export Location


    #=
        LocationSet()
        ----------------------------------------------------
        A set of populations.
    =#
    mutable struct LocationSet
        locations::Vector{Location}
    end
    export LocationSet

    #=
        abstract type declaration
    =#
    abstract type EnvironmentalVariable end

    abstract type LandscapeGenerator end
    abstract type LocationSetGenerator end
    abstract type EnvironmentGenerator end

    # Dispersal abstract types
    abstract type DispersalStructure end
        abstract type IBD <: DispersalStructure end
        abstract type IBR <: DispersalStructure end # omniscape.jl integration (eventually)

    abstract type DispersalPotential end
    abstract type DispersalKernel end
    #


    include(joinpath(".", "generators.jl"))

    #dispersal
    include(joinpath(".", "dispersal/Dispersal.jl"))
    using .Dispersal

    #
    include(joinpath(".", "./environment/Environment.jl"))
    using .Environment



end
