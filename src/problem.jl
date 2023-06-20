struct Problem{T,S<:Spatialness}
    model::Model
    prob::T
    tspan
    initial_condition
    spatialgraph::Union{SpatialGraph, Missing}
end

is_spatial(p::Problem) = !ismissing(p.spatialgraph)
model(p::Problem) = p.model

function problem(m::Model; kwargs...)
    problem(m, Deterministic; kwargs...)
end

function problem(m::Model, ::Type{Deterministic}; tspan=(0,100), u0=nothing)
    prob = discreteness(m) == MetacommunityDynamics.Continuous ? ODEProblem : DiscreteProblem
    
    # this should dispatch on whether a spatialgraph was provided
    f = factory(m) 
    u0 = isnothing(u0) ? initial(m) : u0
    θ = parameters(m)
    pr = prob(f, u0, tspan, θ) 
    Problem{typeof(pr),Local}(m, pr, tspan, u0, Missing())
end

function problem(m::SpatialModel,::Type{Deterministic}; tspan=(0,100), u0=nothing)
    f = factory(m.model, m.diffusion)

    s = numsites(m.spatialgraph)
    u0 = isnothing(u0) ? hcat([initial(m.model) for _ in 1:s]...) : hcat([u0 for _ in 1:s]...)
    θ = parameters(m.model)
    pr = ODEProblem(f, u0, tspan, θ)
    Problem{typeof(pr),Spatial}(m.model, pr, tspan, u0, m.spatialgraph)
end 

function problem(m::SpatialModel, gd::GaussianDrift; tspan=(0,100), u0=nothing)
    f,g = factory(m.model, m.diffusion, gd)

    s = numsites(m.spatialgraph)
    u0 = isnothing(u0) ? hcat([initial(m.model) for _ in 1:s]...) : hcat([u0 for _ in 1:s]...)
    θ = parameters(m.model)
    pr = SDEProblem(f, g, u0, tspan, θ) 
    Problem{typeof(pr),Spatial}(m.model, pr, tspan, u0, m.spatialgraph)
end 


function problem(m::T, gd::GaussianDrift; tspan=(0,100), u0=nothing) where T<:Model
    prob = discreteness(m) == MetacommunityDynamics.Continuous ? SDEProblem : DiscreteProblem

    # this should dispatch on whether a spatialgraph was provided
    f, g = factory(m,gd) 
    u0 = isnothing(u0) ? initial(m) : u0

    θ = parameters(m)

    # This will also enable injection of environment dependent variables here
    # for the spatial version of this method 
    pr = prob(f, g, u0, tspan, θ) 
    Problem{typeof(pr),Local}(m, pr, tspan, u0, Missing())
end



