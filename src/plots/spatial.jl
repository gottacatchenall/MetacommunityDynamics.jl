function makieplot(
    sg::SpatialGraph;
    markersize = 25,
    alphamap = x->1.5x,
    widthmap = x->5exp(x)
)
    coords = (coordinates(sg).coordinates)
    ϕ = sg.potential

    f = Figure(resolution=(900,900))
    ax = Axis(f[1,1])
    for s in CartesianIndices(ϕ)
        ϕᵢⱼ = ϕ[s[1],s[2]]

        lw = widthmap(ϕᵢⱼ)
        lc = (:grey30, alphamap(ϕᵢⱼ))
        CairoMakie.lines!(ax, [x[s[1]], x[s[2]]], [y[s[1]], y[s[2]]], linewidth=lw, color=lc)
    end
    CairoMakie.scatter!(ax, x,y; markersize=markersize)

    f
end 

function makieplot(coords::Coordinates; markersize=25)
    x, y = [i[1] for i in coords.coordinates], [i[2] for i in coords.coordinates]
    f = Figure(resolution=(900,900))
    ax = Axis(f[1,1])
    CairoMakie.scatter!(ax, x,y; markersize=markersize)
    f
end

function makieplot(kern::DispersalKernel)
    xs = LinRange(0, kern.max_distance, 99)
    ys = [kern.func.(x, kern.decay) for x in xs]
    
    ys = ys ./ sum(ys)

    xs = vcat(xs, 2xs[end]-xs[end-1])
    ys = vcat(ys, 0)

    lines(xs, ys)
    current_figure()
end

function replplot(kern::DispersalKernel)
    height,width = displaysize(stdout)  
    
    xs = LinRange(0, kern.max_distance, 99)
    ys = [kern.func.(x, kern.decay) for x in xs]
    
    ys = ys ./ sum(ys)

    xs = vcat(xs, 2xs[end]-xs[end-1])
    ys = vcat(ys, 0)


    p = lineplot(xs, ys,
        xlabel="distance", 
        ylabel="dispersal prob. density", 
        width=width-40,
    )
end
