function factory(m::Model)
    (u,θ,_) -> ∂u(m, u, θ)
end

function factory(m::Model, stoch::T) where {T<:Stochasticity}
    (u,θ,_) -> ∂u(m, u, θ), (u,_,_) -> ∂w(stoch, u)
end

function factory(m::Model, d::T) where {T<:Union{Diffusion,Vector{Diffusion}}}
    (u,θ,_) -> ∂u_spatial(m, diffusion!(u,d), θ)         
end
function factory(m::Model, d::T, stoch::S) where {T<:Union{Diffusion,Vector{Diffusion}}, S<:Stochasticity}
    (u,θ,_) -> ∂u_spatial(m, diffusion!(u,d), θ), (u,_,_) -> ∂w(stoch, u)     
end
