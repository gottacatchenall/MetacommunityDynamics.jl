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
        lines!(ax, time, xs[s,:], linewidth=4)
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
    lines!(ax, time, xs, linewidth=4)
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

    lines!(ax, time, prop, linewidth=4)
    f
end 


function makieplot(::Model{Population,M,Spatial,D}, traj) where {M<:Union{Biomass,Abundance},D}
    a = Array(traj.sol.u)
    T = length(a)
    num_pops = length(a[1])
    
    timeseries = [[a[t][p] for t in 1:T] for p in 1:num_pops]
    ymax = max([extrema(x)[2] for x in timeseries]...)
    
    f = Figure()
    ax = Axis(
        f[1,1],
        xlabel="Time",
        ylabel="Proportion Occupied",
    )
    ylims!(ax, 0, ymax)

    for ts in timeseries
        lines!(ax, ts,linewidth=4)
    end
    f
end 


function makieplot(::Model{Community,M,Spatial,D}, traj) where {M<:Union{Biomass,Abundance},D}
    u = Array(traj.sol)    
    n_species, n_locations, n_timesteps = size(u)
    ymax = max(u...)
         
    cols = n_species < 7 ? [:blue, :red, :green, :red, :purple, :red] : fill(:blue, n_species)
    
    f = Figure()
    ax = Axis(
        f[1,1],
        xlabel="Time",
        ylabel="$M",
    )
    ylims!(ax, 0, ymax)


    for s in eachslice(u, dims=(2))
        for sp in 1:n_species
            lines!(ax, s[sp,:], linewidth=4, color=(cols[sp], 1.0/n_locations))
        end
    end 
    f
end 