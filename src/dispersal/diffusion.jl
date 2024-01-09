struct Diffusion{T}
    matrix::Matrix{T}
end

numsites(d::Diffusion) = size(d.matrix, 1)

Diffusion(sg::SpatialGraph, m::T) where T<:Number = Diffusion(_diffusion_mat(sg,m))
Diffusion(m::T, sg::SpatialGraph) where T<:Number = Diffusion(_diffusion_mat(sg,m))

function _diffusion_mat(sg::SpatialGraph, m::T) where T<:Number
    idx = CartesianIndices(sg.potential)
    [i[1] == i[2] ? 1-m : sg.potential[i[1],i[2]] * m for i in idx]
end

# Dimensionality of u_i matters.
# 

function diffusion!(u::Vector, d::Diffusion)
    u[findall(x->x<0, u)] .= 0
    u = d.matrix * u
end 

function diffusion!(u::Matrix, d::Diffusion)
    u[findall(x->x<0, u)] .= 0
    
    for (i,r) in enumerate(eachrow(u))
        u[i,:] .= d.matrix * r
    end
    return u
end 

# Diffusion is per species level 
function diffusion!(u, d::Vector{Diffusion})
    for (i,r) in enumerate(eachrow(u))
        u[i,:] .= d[i].matrix * r
    end
    u
end 



