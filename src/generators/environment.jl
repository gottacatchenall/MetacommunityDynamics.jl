struct StaticEnvironmentalLayer end 

function  MetacommunityDynamics.generate(::Type{StaticEnvironmentalLayer},
    grid::Array{T,2},
    dist::Distribution;
    mask=nothing) where {T<:Number}
    

    n,m = size(grid)

    for i in 1:n
        for j in 1:m
            if isnothing(mask) || !isnothing(mask) && .!mask[i,j] 
                grid[i,j] = rand(dist)
            end
        end
    end
    
    return grid
end
