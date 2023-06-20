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
    θ = parameters(m)
    Problem(m, prob(f, u0, tspan, θ) , tspan, u0, Missing())
end

function problem(m::SpatialModel,::Type{Deterministic}; tspan=(0,100), u0=nothing)

    f = factory(m.model, m.diffusion)

    s = numsites(m.spatialgraph)
    u0 = isnothing(u0) ? hcat([initial(m.model) for _ in 1:s]...) : hcat([u0 for _ in 1:s]...)
    θ = parameters(m.model)

    Problem(m.model, ODEProblem(f, u0, tspan, θ) , tspan, u0, m.spatialgraph)

    #=
    function f(du, u, p, t)

        # instead of this, we should just have a separate du_dt for spatial 

        for i in 1:s
            plocal = copy(p)
            plocal[1] = p[paramindex][:,i]
            du[:,i] = ∂u(m.model, u[:,i], plocal)
        end

        if typeof(m.diffusion) == Diffusion
            for s in 1:numspecies(m.speciespool)
                @fastmath du[s,:] += m.diffusion * u[s,:]
            end
        else
            for s in 1:numspecies(m.speciespool)
                @fastmath du[s,:] += m.diffusion[s] * u[s,:]
            end
        end

    end 

    Problem(m.model, ODEProblem(f, u0, tspan, θ) , tspan, u0, m.spatialgraph)=#
end 


function problem(m::T, gd::GaussianDrift; tspan=(0,100), u0=nothing) where T<:Model
    prob = discreteness(m) == MetacommunityDynamics.Continuous ? SDEProblem : DiscreteProblem

    # this should dispatch on whether a spatialgraph was provided
    f, g = factory(m,gd) 
    u0 = isnothing(u0) ? initial(m) : u0

    θ = parameters(m)

    # This will also enable injection of environment dependent variables here
    # for the spatial version of this method 
    
    Problem(m, prob(f, g, u0, tspan, θ) , tspan, u0, Missing())
end

function simulate(p::Problem)
    sol = solve(p.prob, saveat=(p.tspan[1]:1:p.tspan[2]))
    Trajectory(p, sol)
end


