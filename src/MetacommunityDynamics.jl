module MetacommunityDynamics

    using Distributions
    using Term
    using UnicodePlots
    using Distances
    using NeutralLandscapes
    using DifferentialEquations

    using TestItems
    
    abstract type Discreteness end 
    abstract type Discrete <: Discreteness end 
    abstract type Continuous <: Discreteness end 
    export Discreteness, Discrete, Continuous


    abstract type Stochasticity end 
    abstract type Deterministic end 
    
    @kwdef struct GaussianDrift{T} <: Stochasticity
        σ::T = 0.1
    end
    
    export Stochasticity, Deterministic

    abstract type Model end 
    export Model
    
    include("environment.jl")
    include("spatialgraph.jl")

    include("problem.jl")
    export simulate 

    include("trajectory.jl")
    
    export Trajectory
    export problem, model, solution, timeseries


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
    export RosenzweigMacArthur 

    export factory
    export discreteness
    export initial
    export replplot 



    export numsites, coordinates, environment, envdims


end # module
