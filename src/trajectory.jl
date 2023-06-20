
"""
    Trajectory{S<:SciMLBase.AbstractTimeseriesSolution}

A trajectory is a single output for a `Problem`.  
"""
struct Trajectory{P<:SciMLBase.AbstractDEProblem,S<:Spatialness,T<:SciMLBase.AbstractTimeseriesSolution,R<:Stochasticity,D<:Discreteness}
    prob::Problem{P,S,R,D}
    sol::T
end
problem(t::Trajectory) = t.prob
model(t::Trajectory) = model(problem(t))
solution(t::Trajectory) = t.sol
timeseries(t::Trajectory) = solution(t).u
Base.length(t::Trajectory) = length(solution(t).t)


_default_solver(::Type{Deterministic}, ::Type{Continuous}) = Tsit5()
_default_solver(::Type{Deterministic}, ::Type{Discrete}) = FunctionMap()
_default_solver(::Type{Stochastic}, ::Type{Continuous}) = SOSRI()
_default_solver(::Type{Stochastic}, ::Type{Discrete}) = nothing

function simulate(p::Problem{P,S,R,C}; solver=nothing) where {P<:SciMLBase.AbstractDEProblem,S<:Spatialness,R<:Stochasticity, C<:Discreteness}
    
    solver = isnothing(solver) ? _default_solver(R,C) : solver

    sol = solve(p.prob, solver, saveat=(p.tspan[1]:1:p.tspan[2]))
    Trajectory{P,S,typeof(sol),R,C}(p, sol)
end

# ====================================================
#
#   Printing
#
# ===================================================
Base.string(traj::Trajectory) = """
An {green}{bold}trajectory{/bold}{/green} of length $(length(traj)).
"""

Base.show(io::IO, ::MIME"text/plain", traj::Trajectory) = begin 
    tprint(io, string(traj))
    print(io, 
        replplot(model(traj), traj)
    )
end 
