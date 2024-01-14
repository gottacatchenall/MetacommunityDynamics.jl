
function replplot(::Model{Community,M,Local,D}, traj) where {M<:Union{Biomass,Abundance},D}
    time = traj.sol.t
    u = timeseries(traj)
    ymax = max([extrema(x)[2] for x in timeseries(traj)]...)
    ts(s) = [mean(u[t][s,:]) for t in 1:length(traj)]

    _,width = displaysize(stdout)    
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


function replplot(::Model{Population,M,Spatial,D}, traj) where {M<:Union{Biomass,Abundance},D}
    a = Array(traj.sol.u)
    T = length(a)
    num_pops = length(a[1])
    
    timeseries = [[a[t][p] for t in 1:T] for p in 1:num_pops]
    ymax = max([extrema(x)[2] for x in timeseries]...)
    _,width = displaysize(stdout)    
    p = lineplot(timeseries[1], 
        xlabel="time (t)", 
        ylabel=string(M), 
        width=width-40,
        ylim=(0,ymax)
    )

    for ts in timeseries[2:end]
        lineplot!(p, ts)
    end
    p
end 

function replplot(::Model{Community,M,Spatial,D}, traj) where {M<:Union{Biomass,Abundance},D}
    u = Array(traj.sol)    
    n_species, n_locations, n_timesteps = size(u)
    ymax = max(u...)
    _,width = displaysize(stdout)    

    p = lineplot(u[1,1,:], 
        xlabel="time (t)", 
        ylabel="Biomass", 
        width=width-40,
        ylim=(0,ymax))
         
    cols = n_species < 7 ? [:blue, :red, :green, :red, :purple, :red] : fill(:blue, n_species)
    for s in eachslice(u, dims=(2))
        for sp in 1:n_species
            lineplot!(p, s[sp,:], color=cols[sp])
        end
    end 
    p
end 
