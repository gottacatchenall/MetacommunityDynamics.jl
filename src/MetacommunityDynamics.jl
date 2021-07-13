module MetacommunityDynamics
    using DynamicGrids
    using DynamicGrids: CellRule, SetCellRule, applyrule, Rule, Ruleset,Neighborhood,Moore;
    using Dispersal: OutwardsDispersal
    using Distributions
    using Crayons
    using EcologicalNetworks

    include(joinpath("types.jl"))
    export Measurement

    include(joinpath("layers", "layer.jl"))
    export Layer
    include(joinpath("layers", "occupancy.jl"))
    export Occupancy
    include(joinpath("layers", "biomass.jl"))
    export Biomass


    include(joinpath("generators", "poissonprocess.jl"))
    export generate, PoissonProcess, grid, pointstogrid


    include(joinpath("generators", "environment.jl"))
    export StaticEnvironmentalLayer


    include(joinpath("mechanisms", "_combinemechanisms.jl"))
    include(joinpath("mechanisms", "selection.jl"))
    export FitnessFunction, GaussianFitness, ExponentialFitness, DensityDependentFitness, AbioticSelection, BioticSelection

    include(joinpath("mechanisms", "colonization.jl"))
    export RandomColonization, SpatiallyExplicitLevinsColonization, LevinsColonization

    include(joinpath("mechanisms", "extinction.jl"))
    export RandomExtinction, AbioticExtinction

    include(joinpath("mechanisms", "eating.jl"))
    export Eating, FunctionalResponse, HollingTypeI, HollingTypeII, HollingTypeIII, LinearFunctionalResponse, LotkaVolterra, MichaelisMenten, CrowleyMartin

    include(joinpath("mechanisms", "mortality.jl"))
    export Mortality, LinearMortality


    include(joinpath("mechanisms", "dispersal.jl"))
    export AdjacentBernoulliDispersal

    include(joinpath("mechanisms", "growth.jl"))
    export LogisticGrowth


    include(joinpath("mechanisms", "growth.jl"))
    export LogisticGrowth

    include(joinpath("species", "speciespool.jl"))
    export ContinuousSpeciesPool, DiscreteSpeciesPool 
    export SingleSpecies, DiscreteUnipartiteSpeciesPool, DiscreteKpartiteSpeciesPool,ContinuousUnipartiteSpeciesPool, ContinuousKpartiteSpeciesPool
    export speciespool, specieslayers, nspecies, species
    include(joinpath("species", "printing.jl"))


end # module



