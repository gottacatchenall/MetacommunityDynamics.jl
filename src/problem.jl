struct Problem{T <: SciMLBase.AbstractDEProblem}
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

    # TODO replace params here with a value loaded via
    # parameters(m). 

    # This will also enable injection of environment dependent variables here
    # for the spatial version of this method 

    Problem(m, prob(f, u0, tspan, ()) , tspan, u0, Missing())
end


function problem(m::Model, gd::GaussianDrift; tspan=(0,100), u0=nothing)
    

    prob = discreteness(m) == MetacommunityDynamics.Continuous ? ODEProblem : DiscreteProblem
    


    # this should dispatch on whether a spatialgraph was provided
    f, g = factory(m,gd) 
    u0 = isnothing(u0) ? initial(m) : u0

    # TODO replace params here with a value loaded via
    # parameters(m). 

    # This will also enable injection of environment dependent variables here
    # for the spatial version of this method 
    
    Problem(m, prob(f, g, u0, tspan, ()) , tspan, u0, Missing())
end

function simulate(p::Problem)
    sol = solve(p.prob, saveat=(p.tspan[1]:1:p.tspan[2]))
    Trajectory(p, sol)
end


