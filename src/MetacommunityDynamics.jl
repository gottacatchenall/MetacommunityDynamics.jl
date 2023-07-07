module MetacommunityDynamics

    using Distributions
    using Term
    using UnicodePlots
    using Distances
    using NeutralLandscapes
    using DifferentialEquations

    using TestItems
    
    include("types.jl")
    include("model.jl")
    include("drift.jl")
    
    include("parameters.jl")

    include("environment.jl")
    include("coordinates.jl")

    include("species.jl")


    include(joinpath("dispersal", "kernel.jl"))

    include("spatialgraph.jl")
    include(joinpath("dispersal", "diffusion.jl"))

    include(joinpath("dispersal", "spatialize.jl"))



    include("problem.jl")
    include("trajectory.jl")
    include("observer.jl")
    
    include("factory.jl")

    include(joinpath("models", "ricker.jl"))
    include(joinpath("models", "bevertonholt.jl"))
    include(joinpath("models", "logistic.jl"))


    include(joinpath("models", "lvcompetition.jl"))
    include(joinpath("models", "rosenzweigmacarthur.jl"))

    include(joinpath("models", "levins.jl"))


    export Diffusion, SpatialModel
    export diffusion!

    export factory
    
    export Model
    export Scale, Population, Metapopulation, Community, Metacommunity
    export Spatialness, Local, Spatial
    export Discreteness, Discrete, Continuous
    export Measurement, Biomass, Abundance, Occupancy
    export Stochasticity, Deterministic, Stochastic
    
    export Parameter

    export GaussianDrift

    export discreteness, spatialness, measurement, stochasticity

    export parameters, paramdict

    export spatialize

    export Coordinates
    export SpatialGraph
    export DispersalKernel
    
    export kernel
    export max_distance, decay

    export multispecies

    export Species, SpeciesPool, Niche, GaussianNiche
    export EnvironmentLayer

    export BevertonHolt
    export Ricker
    export CompetitiveLotkaVolterra
    export RosenzweigMacArthur 
    export LogisticModel

    export LevinsMetapopulation

    export GaussianNiche, Niche

    export two_species
    export growthrate, growthratename

    export factory
    export discreteness
    export initial
    export replplot 

    export numspecies
    export traitdims
    export traitnames

    export Observer, observe
    export simulate 

    
    export Trajectory
    export problem, model, solution, timeseries



    export numsites, coordinates, environment, envdims


end # module
