struct Problem{T <: SciMLBase.AbstractODEProblem}
    model::Model
    prob::T
    tspan
    initial_condition
    spatialgraph::Union{SpatialGraph, Missing}
end

model(p::Problem) = p.model
function problem(m::Model, ::Type{Deterministic}; tspan=(0,100), u0=nothing)
    prob = discreteness(m) == MetacommunityDynamics.Continuous ? ODEProblem : DiscreteProblem
    f = factory(m) 
    u0 = isnothing(u0) ? initial(m) : u0
    Problem(m, prob(f, u0, tspan, ()) , tspan, u0, Missing())
end
function simulate(p::Problem)
    sol = solve(p.prob, saveat=(p.tspan[1]:1:p.tspan[2]))
    Trajectory(p, sol)
end



function model(m::Model, ::Deterministic, ::SpatialGraph)
        
end


function model(m::Model, ::GaussianDrift, ::SpatialGraph)

end 
