module MetacommunityDynamics

    using Distributions
    using Term
    using UnicodePlots
    using Distances
    using NeutralLandscapes
    
    using TestItems
    
    abstract type Model end 
    export Model
    
    include("environment.jl")
    include("spatialgraph.jl")

    include(joinpath("dispersal", "kernel.jl"))
    include(joinpath("dispersal", "potential.jl"))

    include("species.jl")

    include(joinpath("models", "ricker.jl"))
    include(joinpath("models", "bevertonholt.jl"))

    include(joinpath("models", "lvcompetition.jl"))
    include(joinpath("models", "rosenzweigmacarthur.jl"))


    export SpatialGraph
    export DispersalKernel
    export DispersalPotential


    export Species, SpeciesPool, Niche, GaussianNiche
    export EnvironmentLayer

    export BevertonHolt
    export Ricker
    export CompetitiveLotkaVolterra


    export numsites, coordinates, environment, envdims


end # module
