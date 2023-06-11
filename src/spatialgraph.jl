@kwdef struct SpatialGraph{T} 
    coordinates::Vector{Tuple{T,T}} = [(rand(), rand()) for _ = 1:20]
end
SpatialGraph(n::Integer) = SpatialGraph([(rand(), rand()) for _ = 1:n])


numsites(sg::SpatialGraph) = length(coordinates(sg))
coordinates(sg::SpatialGraph) = sg.coordinates


function _spatialgraph_to_text(sg)
    str = string(
        scatterplot(
            [x[1] for x in sg.coordinates],
            [x[2] for x in sg.coordinates],
            xlim = (0, 1),
            ylim = (0, 1),
            padding=0,
        ),
    )
    replace(str, "." => "[green].[/green]")
end

Base.string(sg::SpatialGraph) = """
An {green}{bold}spatial graph{/bold}{/green} with {bold}{blue}$(length(sg.coordinates)){/blue}{/bold} locations.
"""

Base.show(io::IO, ::MIME"text/plain", sg::SpatialGraph) = begin 
    tprint(io, string(sg))
    print(io, 
        scatterplot(
            [x[1] for x in sg.coordinates],
            [x[2] for x in sg.coordinates],
            xlim = (0, 1),
            ylim = (0, 1),
            padding=0,
            marker=:circle
        )
    )
end 

a = SpatialGraph(15)


"""
    distancematrix(sg::SpatialGraph; distance = Euclidean())
    
Returns a matrix of pairwise distances for all nodes in a `SpatialGraph` 
"""
function distance_matrix(sg::SpatialGraph; distance = Euclidean())
    distmat = zeros(numsites(sg), numsites(sg))

    for i = 1:numsites(sg), j = 1:numsites(sg)
        x, y = sg.coordinates[i], sg.coordinates[j]
        distmat[i, j] = evaluate(distance, (x[1], x[2]), (y[1], y[2]))
    end
    distmat
end