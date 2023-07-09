function factory(m::Model{SC,M,Local,D}) where {SC<:Union{Population,Community},M,D}
    (u,θ,_) -> ∂u(m, u, θ)
end

function factory(m::Model{SC,M,SP,D}, stoch::T) where {SC<:Union{Population,Community},M,SP,D,T<:Stochasticity}
    (u,θ,_) -> ∂u(m, u, θ), (u,_,_) -> ∂w(stoch, u)
end

function factory(m::Model{SC,M,Spatial,D}, d::T) where {T<:Union{Diffusion,Vector{Diffusion}},SC<:Union{Population,Community},M,D}
    return _spatial_factory(m,d)
end

function factory(m::Model{SC,M,Spatial,D}, d::T, stoch::S) where {T<:Union{Diffusion,Vector{Diffusion}},S<:Stochasticity,SC<:Union{Population,Community},M,D}
    _spatial_factory(m,d), (u,_,_) -> ∂w(stoch, u)     
end

function factory(m::Model{SC,M,Spatial,D}) where {SC<:Union{Metapopulation,Metacommunity},M,D}
    (u,θ,_) -> ∂u(m, u, θ)
end


function _spatial_factory(m::Model, d::Diffusion) 
    function f(u, θ, _)
        du = similar(u)
        ns = numsites(d)
        diffusion!(u,d)
        
        for s in 1:ns
            u_local = u[:,s]    
            θ_local = [x[s] for x in θ]
            du[:,s] .= ∂u(m, u_local, θ_local)
        end 
        du 
    end
    return f
end 

