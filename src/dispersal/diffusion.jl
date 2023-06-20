struct Diffusion{T}
    matrix::Matrix{T}
end

Diffusion(ϕ::DispersalPotential, m::T) where T<:Number = Diffusion(_diffusion_mat(ϕ,m))
Diffusion(m::T, ϕ::DispersalPotential) where T<:Number = Diffusion(_diffusion_mat(ϕ,m))

function _diffusion_mat(ϕ::DispersalPotential, m::T) where T<:Number
    idx = CartesianIndices(ϕ.matrix)
    [i[1] == i[2] ? 1-m : ϕ[i[1],i[2]] * m for i in idx]
end

function diffusion(u, d::Diffusion)
    du = similar(u)
    du .= 0
    for (i,r) in enumerate(eachrow(u))
        du[i,:] .= d.matrix * r
    end

    du = Matrix((d.matrix * u')')
end 

