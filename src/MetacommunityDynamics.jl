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


    abstract type Stochasticity end 
    abstract type Stochastic <: Stochasticity end 
    abstract type Deterministic <: Stochasticity end 
    
    abstract type Spatialness end 
    abstract type Local <: Spatialness end 
    abstract type Spatial <: Spatialness end 


    @kwdef struct GaussianDrift{T} <: Stochasticity
        σ::T = 0.1
    end

    function ∂w(gd::GaussianDrift, x::T) where T<:Real
        gd.σ
    end
    function ∂w(gd::GaussianDrift, x::Vector{T}) where T<:Real
        [gd.σ for _ in 1:length(x)]
    end
    function ∂w(gd::GaussianDrift, x::Matrix{T}) where T<:Real
        σ = similar(x)
        σ .= gd.σ
    end
    


    abstract type Model end 
    function paramdict(m::Model)
        fns = paramnames(m)
        Dict{Symbol, Array}([f=>getfield(m, f) for f in fns]...)
    end
    function parameters(m::Model)
        # everything but M is a paremeter
        fns = paramnames(m)
        [getfield(m, f) for f in fns]
    end
    

    include("environment.jl")
    include("spatialgraph.jl")


    include("species.jl")
    include("niche.jl")


    include(joinpath("dispersal", "kernel.jl"))
    include(joinpath("dispersal", "potential.jl"))
    include(joinpath("dispersal", "diffusion.jl"))
    include(joinpath("dispersal", "spatialmodel.jl"))

    include("problem.jl")
    include("trajectory.jl")
    include("observer.jl")
    
    include("factory.jl")

    include(joinpath("models", "ricker.jl"))
    include(joinpath("models", "bevertonholt.jl"))
    include(joinpath("models", "logistic.jl"))


    include(joinpath("models", "lvcompetition.jl"))
    include(joinpath("models", "rosenzweigmacarthur.jl"))

    export Diffusion, SpatialModel
    export diffusion!

    export factory
    
    export Model
    export Spatialness, Local, Spatial
    export Discreteness, Discrete, Continuous
    export Stochasticity, Deterministic, GaussianDrift

    export parameters
    export paramdict

    export spatialize

    export SpatialGraph
    export DispersalKernel
    export DispersalPotential


    export Species, SpeciesPool, Niche, GaussianNiche
    export EnvironmentLayer

    export BevertonHolt
    export Ricker
    export CompetitiveLotkaVolterra
    export RosenzweigMacArthur 
    export LogisticModel

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
