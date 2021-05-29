module MetacommunityDynamics
    using DynamicGrids
    using DynamicGrids: applyrule
    using Distributions


    include(joinpath("layers", "occupancy.jl"))
    export Occupancy

    include(joinpath("mechanisms", "selection.jl"))
    export FitnessFunction, GaussianFitness, DensityDependentFitness, AbioticSelection, BioticSelection

    include(joinpath("mechanisms", "colonization.jl"))
    export RandomColonization

    include(joinpath("mechanisms", "extinction.jl"))
    export RandomExtinction


end # module

