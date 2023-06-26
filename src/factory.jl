function factory(m::Model{SC,M,Local,D}) where {SC,M,D}
    (u,θ,_) -> ∂u(m, u, θ)
end

function factory(m::Model, stoch::T) where {T<:Stochasticity}
    (u,θ,_) -> ∂u(m, u, θ), (u,_,_) -> ∂w(stoch, u)
end

function factory(m::Model{SC,M,Spatial,D}, d::T) where {T<:Union{Diffusion,Vector{Diffusion}},SC,M,D}
    # 


    (u,θ,_) -> ∂u_spatial(m, diffusion!(u,d), θ)         
end

function factory(m::Model{SC,M,Spatial,D}, d::T, stoch::S) where {T<:Union{Diffusion,Vector{Diffusion}}, S<:Stochasticity,SC,M,D}
    (u,θ,_) -> ∂u_spatial(m, diffusion!(u,d), θ), (u,_,_) -> ∂w(stoch, u)     
end



# So we want to spatialize a ∂u function 

# Need a norm for whether species/locations are on cols/rows 
# Should match with Parameters

function foo(m::Model{SC,M,Spatial,D}) where {SC,M,D}
    (u, _, _) -> ∂u(m, u)
    


end
