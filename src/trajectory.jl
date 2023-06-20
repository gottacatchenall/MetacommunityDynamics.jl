
"""
    Trajectory{S<:SciMLBase.AbstractTimeseriesSolution}

A trajectory is a single output for a `Problem`.  
"""
struct Trajectory{P<:SciMLBase.AbstractDEProblem,S<:Spatialness,T<:SciMLBase.AbstractTimeseriesSolution}
    prob::Problem{P,S}
    sol::T
end
problem(t::Trajectory) = t.prob
model(t::Trajectory) = model(problem(t))
solution(t::Trajectory) = t.sol
timeseries(t::Trajectory) = solution(t).u
Base.length(t::Trajectory) = length(solution(t).t)


function simulate(p::Problem{P,S}) where {P<:SciMLBase.AbstractDEProblem,S<:Spatialness}
    sol = solve(p.prob, saveat=(p.tspan[1]:1:p.tspan[2]))
    Trajectory{P,S, typeof(sol)}(p, sol)
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
