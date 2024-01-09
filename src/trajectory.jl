
"""
    Trajectory{S<:SciMLBase.AbstractTimeseriesSolution}

A trajectory is a single output for a `Problem`.  
"""
struct Trajectory{T}
    prob::Problem
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
_default_solver(::Type{Stochastic}, ::Type{Discrete}) = FunctionMap()

function simulate(p::Problem; solver=nothing) 

    d = discreteness(p)
    s = stochasticity(p)

    solver = isnothing(solver) ? _default_solver(s,d) : solver

    sol = solve(p.prob, solver, saveat=(p.tspan[1]:1:p.tspan[2]))
    Trajectory{typeof(sol)}(p, sol)
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

