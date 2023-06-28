struct Diffusion{T}
    matrix::Matrix{T}
end

numsites(d::Diffusion) = size(d.matrix, 1)

Diffusion(ϕ::DispersalPotential, m::T) where T<:Number = Diffusion(_diffusion_mat(ϕ,m))
Diffusion(m::T, ϕ::DispersalPotential) where T<:Number = Diffusion(_diffusion_mat(ϕ,m))

function _diffusion_mat(ϕ::DispersalPotential, m::T) where T<:Number
    idx = CartesianIndices(ϕ.matrix)
    [i[1] == i[2] ? 1-m : ϕ[i[1],i[2]] * m for i in idx]
end

function diffusion!(u, d::Diffusion)
    for (i,r) in enumerate(eachrow(u))
        u[i,:] .= d.matrix * r
    end
    u
end 


function diffusion!(u, d::Vector{Diffusion})
    for (i,r) in enumerate(eachrow(u))
        u[i,:] .= d[i].matrix * r
    end
    u
end 


