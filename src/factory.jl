function factory(m::Model{SC,M,Local,D}) where {SC,M,D}
    (u,θ,_) -> ∂u(m, u, θ)
end

function factory(m::Model, stoch::T) where {T<:Stochasticity}
    (u,θ,_) -> ∂u(m, u, θ), (u,_,_) -> ∂w(stoch, u)
end

function factory(m::Model{SC,M,Spatial,D}, d::T) where {T<:Union{Diffusion,Vector{Diffusion}},SC,M,D}
    return _spatial_factory(m,d)
end

function factory(m::Model{SC,M,Spatial,D}, d::T, stoch::S) where {T<:Union{Diffusion,Vector{Diffusion}}, S<:Stochasticity,SC,M,D}
    _spatial_factory(m,d), (u,_,_) -> ∂w(stoch, u)     
end


function _spatial_factory(m::Model, d::Diffusion) 
    function f(u, θ, _)
        du = similar(u)
        ns = numsites(d)
        diffusion!(u,d)
        
        for s in 1:ns
            u_local = u[:,s]    
            θ_local = [x[s] for x in θ]
            du[:,s] = ∂u(m, u_local, θ_local)
        end 
        du 
    end
    return f
end 