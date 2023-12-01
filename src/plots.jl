
makieplot(traj::Trajectory) = makieplot(traj.prob.model, traj)

function makieplot(m::Model{Community,M,Local,D}, traj) where {M<:Union{Biomass,Abundance},D}
    ns = numspecies(m)

    time = traj.sol.t

    f = Figure()
    ax = Axis(
        f[1,1],
        xlabel="Time",
        ylabel=string(M)
    )

    xs = Array(sol.sol)
    for s in 1:ns
        scatterlines!(ax, time, xs[s,:])
    end
    f
end 

function makieplot(::Model{Population,M,Local,D}, traj) where {M<:Union{Biomass,Abundance},D}
    time = traj.sol.t
    f = Figure()
    ax = Axis(
        f[1,1],
        xlabel="Time",
        ylabel=string(M)
    )
    xs = Array(sol.sol)
    scatterlines!(ax, time, xs)
    f
end 

function makieplot(::Model{Metapopulation,Occupancy,S,D}, traj) where {S,D}
    time = traj.sol.t
    f = Figure()
    ax = Axis(
        f[1,1],
        xlabel="Time",
        ylabel="Proportion Occupied",
    )
    ylims!(ax, 0,1)
    xs = Array(traj.sol)
    prop = [sum(c)/length(c) for c in eachcol(xs)]

    scatterlines!(ax, time, prop)
    f
end 

