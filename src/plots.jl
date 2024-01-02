
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

    xs = hcat(Array(traj.sol.u)...)
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
    xs = Array(traj.sol)
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




function replplot(m::Model{Community,M,Local,D}, traj) where {M<:Union{Biomass,Abundance},D}
    ns = numspecies(m)
    time = traj.sol.t
    u = timeseries(traj)
    ymax = max([extrema(x)[2] for x in timeseries(traj)]...)
    ts(s) = [mean(u[t][s,:]) for t in 1:length(traj)]

    height,width = displaysize(stdout)    
    p = lineplot(time, ts(1), 
        xlabel="time (t)", 
        ylabel=string(M), 
        width=width-40,
        ylim=(0,ymax)
    )

    for i in 2:length(u[1])
        lineplot!(p, ts(i))
    end 
    p
end 


function replplot(::Model{Population,M,Local,D}, traj) where {M<:Union{Biomass,Abundance},D}
    time = traj.sol.t
    u = timeseries(traj)
    ymax = max([extrema(x)[2] for x in timeseries(traj)]...)
    _,width = displaysize(stdout)    
    p = lineplot(time, [u[t] for t in 1:length(traj)], 
        xlabel="time (t)", 
        ylabel=string(M),
        width=width-40,
        ylim=(0,ymax)
    )
    p
end 
