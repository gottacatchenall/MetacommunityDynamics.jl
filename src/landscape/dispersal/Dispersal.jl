module Dispersal
    using ..MetacommunityDynamics
    using ..Landscapes
    using ..MetacommunityDynamics.MCDParams
    # Abstract type definitions

    #=
    DispersalKernel
    -----------------------------------------------------------
        An abstract type which represents a set of parameters
        for a specific dynamics model.
    =#
    abstract type DispersalKernel end
    export DispersalKernel

    # Include files with constructors for dispersal stuff
    include(joinpath(".", "dispersal_kernels.jl"))


    #=
    DispersalPotentialGenerator
    -----------------------------------------------------------
        An abstract type for an object that generates a dispersal potentital according to a set of parameters.
    =#
    abstract type DispersalPotentialGenerator end
    export DispersalPotentialGenerator


    #=
    DispersalPotential
    -----------------------------------------------------------
        A type which holds a matrix of floats, where matrix[i,j]
        is the probability an individual born in i reproduces in j,
        given that individual migrates during its lifetime.

        Note that this forms a probabiity distribution over j for all i,
        meaning that sum_j matrix[i,j] = 1 for all i.
    "=#

    struct DispersalPotential
        matrix::Array{Float64}
    end
    Base.size(potential::DispersalPotential) = size(potential.matrix)
    Base.length(potential::DispersalPotential) = size(potential.matrix)[1]
    Base.getindex(potential::DispersalPotential, x, y) = potential.matrix[x,y]

    include(joinpath(".", "dispersal_potential_generators.jl"))
    DispersalPotential(; locations = LocationSet(), generator=DispersalPotentialGenerators.IBDandCutoff()) = generator(locations=locations)

    export DispersalPotential

    abstract type DispersalType end

    struct DispersalModel
        locations::LocationSet
        potential::DispersalPotential
    end
    DispersalModel(; locations=LocationSet()) = DispersalModel(locations, DispersalPotential(locations=locations))
    export DispersalModel


end
