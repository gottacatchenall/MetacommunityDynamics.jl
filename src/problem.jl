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




# lot's of redudant code here, there are def way to shorten number of lines here

function problem(m::Model{SC,M,Local,D}; tspan=(0,100), u0=nothing) where {SC,M,D}
    prob = D == Continuous ? ODEProblem : DiscreteProblem
    
    f = factory(m) 
    u0 = isnothing(u0) ? initial(m) : u0
    θ = ()
    pr = prob(f, u0, tspan, θ) 
    Problem{typeof(pr),Deterministic}(m, pr, tspan, u0)
end

function problem(m::Model{SC,M,Local,D}, gd::GaussianDrift; tspan=(0,100), u0=nothing) where {SC,M,D}
    prob = D == Continuous ? SDEProblem : DiscreteProblem

    f, g = factory(m, gd) 
    u0 = isnothing(u0) ? initial(m) : u0
    θ = ()

    pr = prob(f, g, u0, tspan, θ) 
    Problem{typeof(pr),Stochastic}(m, pr, tspan, u0)
end

function problem(model::Model{SC,M,S,D}, diffusion::Diffusion; tspan=(0,100), u0=nothing) where {SC,M,S,D}
    S != Spatial && throw("Can't combine Diffusion with a Local model.")

    f = factory(model, diffusion)

    prob = D == Continuous ? ODEProblem : DiscreteProblem

    s = numsites(m.spatialgraph)
    u0 = isnothing(u0) ? hcat([initial(model) for _ in 1:s]...) : hcat([u0 for _ in 1:s]...)
    θ = ()

    pr = prob(f, u0, tspan, θ)

    Problem{typeof(pr),Stochastic}(model, pr, tspan, u0)
end 

function problem(model::Model{SC,M,S,D}, diffusion::Diffusion, gd::GaussianDrift; tspan=(0,100), u0=nothing) where {SC,M,S,D}
    S != Spatial && throw("Can't combine Diffusion with a Local model.")
  
    prob = D == Continuous ? SDEProblem : DiscreteProblem

    f,g = factory(model, diffusion, gd)

    u0 = isnothing(u0) ? hcat([initial(model) for _ in 1:s]...) : hcat([u0 for _ in 1:s]...)
    θ = ()

    pr = prob(f, g, u0, tspan, θ) 
    Problem{typeof(pr),Stochastic}(model, pr, tspan, u0)
end 



