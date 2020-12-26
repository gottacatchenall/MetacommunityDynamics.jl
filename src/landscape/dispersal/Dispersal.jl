module Dispersal
    using ..MetacommunityDynamics
    using ..Landscape
    using ..MetacommunityDynamics.MCDParams
    # Abstract type definitions

    #=
    DispersalKernel
    -----------------------------------------------------------
        An abstract type which represents a set of parameters
        for a specific dynamics model.
    =#
    abstract type DispersalKernel end


    #DispersalPotential(S::LocationSet) = IBDwCutoff()(S)

    #=
    DispersalPotentialGenerator
    -----------------------------------------------------------
        An abstract type for an object that generates a dispersal potentital according to a set of parameters.
    =#
    abstract type DispersalPotentialGenerator end

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

    # Include files with constructors for dispersal stuff
    include(joinpath(".", "dispersal_kernels.jl"))
    include(joinpath(".", "dispersal_potential.jl"))

    export DispersalPotential, distance
end
