function makiephaseplot(m::Model{Community,M,Local,D}, traj; dims=(1,2)) where {M,D}
    f = Figure()
    ax = Axis(
        f[1,1],
        xlabel="Species $(dims[1]) $M",
        ylabel="Species $(dims[2]) $M",
    )
    u = Array(traj.sol)


    x,y = u[dims[1],:], u[dims[2],:]
    coord = collect(zip(x,y))

    pairs = [(coord[t],coord[t-1]) for t in 2:length(coord)]
    rots = []
    
    for p in pairs
        (i,j), (x,y) = p[1], p[2]
        foo = j > i ? 1 : -1
        angle =  tanh( foo * (y-j)/(x-i) ) 
        push!(rots, foo*angle)
    end 
    @info rots
    scatter!(ax, u[dims[1],1:end-1], u[dims[2], 1:end-1],  marker = :utriangle, rotations=rots)
    lines!(ax, u[dims[1],:], u[dims[2], :])

    f 
end

function makiephaseplot(m::Model{Community,M,Spatial,D}, traj; dims=(1,2)) where {M,D}
    f = Figure()
    ax = Axis(
        f[1,1],
        xlabel="Species $(dims[1]) $M",
        ylabel="Species $(dims[2]) $M",
    )

    u = Array(traj.sol)


    x,y = u[dims[1],i_site,:], u[dims[2],i_site,:]

    @info y .- x

    for i_site in axes(u,2)
        scatterlines!(ax, u[dims[1],i_site,:], u[dims[2],i_site,:])
    end
    f
end
