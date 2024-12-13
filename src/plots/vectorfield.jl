function plotvectorfield(
    m::Model{Community,M,Local,D};
    xrange=(0,1), 
    yrange=(0,1),
    numticks=30,
    lengthscale=0.3,
    arrowsize = 6,
    dims=(1,2)
) where {M,D}
    f = factory(m)    
    θ = parameters(m)

    fig = Figure()
    ax = Axis(fig[1, 1], backgroundcolor = "black")

    arrow_func = x -> f(x, θ, nothing)
    xs = LinRange(xrange[begin], xrange[end], numticks)
    ys = LinRange(yrange[begin], xrange[end], numticks)

    us = [arrow_func([x,y])[dims[1]] for x in xs, y in ys]
    vs = [arrow_func([x,y])[dims[2]] for x in xs, y in ys]
    strength = vec(sqrt.(us .^ 2 .+ vs .^ 2))

    arrows!(ax, xs, ys, arrow_func, 
        arrowsize = arrowsize, 
        lengthscale = lengthscale,
        arrowcolor = strength, linecolor = strength
    )

    fig
end