
"""
    Trajectory{S<:SciMLBase.AbstractTimeseriesSolution}

A trajectory is a single output for a `Problem`.  
"""
struct Trajectory{S<:SciMLBase.AbstractTimeseriesSolution}
    prob::Problem
    sol::S
end
problem(t::Trajectory) = t.prob
model(t::Trajectory) = model(problem(t))
solution(t::Trajectory) = t.sol
timeseries(t::Trajectory) = solution(t).u
Base.length(t::Trajectory) = length(solution(t).t)

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
