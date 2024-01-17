function factory(m::Model{SC,M,Local,D}) where {SC<:Union{Population,Community},M,D}
    (u,θ,_) -> ∂u(m, u, θ)
end

function factory(m::Model{SC,M,SP,D}, stoch::T) where {SC<:Union{Population,Community},M,SP,D,T<:Stochasticity}
    (u,θ,_) -> ∂u(m, u, θ), (u,_,_) -> ∂w(stoch, u)
end

function factory(m::Model{SC,M,Spatial,D}, d::T) where {V<:Number,T<:Union{Diffusion{V},Vector{Diffusion{V}}},SC<:Union{Population,Community},M,D}
    return _spatial_factory(m,d)
end

function factory(m::Model{SC,M,Spatial,D}, d::Diffusion, stoch::S) where {S<:Stochasticity,SC<:Union{Population,Community},M,D}
    _spatial_factory(m,d), (u,_,_) -> ∂w(stoch, u)     
end

function factory(m::Model{SC,M,Spatial,D}) where {SC<:Union{Metapopulation,Metacommunity},M,D}
    (u,θ,_) -> ∂u(m, u, θ)
end


function _spatial_factory(m::Model{Population,M,SP,D}, d::Diffusion) where {M,SP,D}
    function f(u, θ, _)
        du = similar(u)
        ns = numsites(d)
        diffusion!(u,d)

        for s in 1:ns
            u_local = u[s]    
            θ_local = [x[s] for x in θ]
            du[s] = ∂u(m, u_local, θ_local)
        end 
        du 
    end
    return f
end 

function _spatial_factory(m::Model{Community,M,SP,D}, d::Diffusion) where {M,SP,D}
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

function _spatial_factory(m::Model{Community,M,SP,D}, diffusion_by_species::Vector{Diffusion{T}}) where {M,SP,D,T}
    function f(u, θ, _)
        du = similar(u)
        nsites = numsites(diffusion_by_species)
        nspecies = numspecies(m)
        for i_sp in 1:nspecies
            diffusion!(u[i_sp,:],diffusion_by_species[i_sp])
        end
        
        for i_site in 1:nsites
            u_local = u[:,i_site]    
            θ_local = [x[i_site] for x in θ]
            du[:,i_site] .= ∂u(m, u_local, θ_local)
        end 
        du 
    end
    return f

end