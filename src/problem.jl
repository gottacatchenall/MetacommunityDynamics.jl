struct Problem{T,R<:Stochasticity}
    model::Model
    prob::T
    tspan
    initial_condition
end

discreteness(p::Problem) = discreteness(model(p))
spatialness(p::Problem) = spatialness(model(p))
measurement(p::Problem) = measurement(model(p))
stochasticity(::Problem{T,R}) where {T,R} = R

model(p::Problem) = p.model

# lot's of redundant code here, there are def way to shorten number of lines here

function problem(m::Model{SC,M,Local,D}; tspan=(0,100), u0=nothing) where {SC<:Union{Population,Community},M,D}
    prob = D == Continuous ? ODEProblem : DiscreteProblem
    
    f = factory(m) 
    u0 = isnothing(u0) ? initial(m) : u0
    θ = parameters(m)

    pr = prob(f, u0, tspan, θ) 
    Problem{typeof(pr),Deterministic}(m, pr, tspan, u0)
end

function problem(m::Model{SC,M,Spatial,D}; tspan=(0,100), u0=nothing) where {SC<:Union{Metapopulation,Metacommunity},M,D}
    prob = DiscreteProblem
    
    f = factory(m) 
    u0 = isnothing(u0) ? initial(m) : u0

    θ = parameters(m)

    pr = prob(f, u0, tspan, θ) 
    Problem{typeof(pr),Deterministic}(m, pr, tspan, u0)
end


function problem(m::Model{SC,M,Local,D}, gd::GaussianDrift; tspan=(0,100), u0=nothing) where {SC,M,D}
    prob = D == Continuous ? SDEProblem : DiscreteProblem

    f, g = factory(m, gd) 
    u0 = isnothing(u0) ? initial(m) : u0
    θ = parameters(m)

    pr = prob(f, g, u0, tspan, θ) 
    Problem{typeof(pr),Stochastic}(m, pr, tspan, u0)
end

function problem(model::Model{SC,M,S,D}, diffusion::Diffusion; tspan=(0,100), u0=nothing) where {SC,M,S,D}
    S != Spatial && throw(ArgumentError, "Can't combine Diffusion with a Local model.")
    f = factory(model, diffusion)

    prob = D == Continuous ? ODEProblem : DiscreteProblem

    s = numsites(diffusion)
    u0 = isnothing(u0) ? hcat([initial(model) for _ in 1:s]...) : hcat([u0 for _ in 1:s]...)
    θ = parameters(model)

    pr = prob(f, u0, tspan, θ)

    Problem{typeof(pr),Deterministic}(model, pr, tspan, u0)
end 

function problem(model::Model{SC,M,S,D}, diffusion::Diffusion, gd::GaussianDrift; tspan=(0,100), u0=nothing) where {SC,M,S,D}
    S != Spatial && throw(ArgumentError, "Can't combine Diffusion with a Local model.")
  
    prob = D == Continuous ? SDEProblem : DiscreteProblem

    s = numsites(diffusion)

    f,g = factory(model, diffusion, gd)

    u0 = isnothing(u0) ? hcat([initial(model) for _ in 1:s]...) : hcat([u0 for _ in 1:s]...)
    θ = parameters(model)

    pr = prob(f, g, u0, tspan, θ) 
    Problem{typeof(pr),Stochastic}(model, pr, tspan, u0)
end 


# Printing

Base.string(p::Problem{T,R}) where {T,R} = """
A {blue}$R{/blue} {bold}{#a686eb}Problem{/#a686eb}{/bold} 
- model: $(typeof(p.model)) $(spatialness(p.model))
- u0: $(p.initial_condition)
- tspan: $(p.tspan)
"""

Base.show(io::IO,  p::Problem{T,R}) where {T,R} = tprint(p)


