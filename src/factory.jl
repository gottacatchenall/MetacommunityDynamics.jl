function factory(m::Model)
    (u,_,_) -> ∂u(m, u)
end

function factory(m::Model, stoch::T) where {T<:Stochasticity}
    (u,_,_) -> ∂u(m, u), (u,_,_) -> ∂w(stoch, u)
end

function factory(m::Model, d::T) where {T<:Union{Diffusion,Vector{Diffusion}}}
    (u,_,_) -> ∂u_spatial(m, diffusion!(u,d))         
end
function factory(m::Model, d::T, stoch::S) where {T<:Union{Diffusion,Vector{Diffusion}}, S<:Stochasticity}
    (u,_,_) -> ∂u_spatial(m, diffusion!(u,d)), (u,_,_) -> ∂w(stoch, u)     
end



# So we want to spatialize a ∂u function 

# Need a norm for whether species/locations are on cols/rows 
# Should match with Parameters

function foo(m::Model{SC,M,Spatial,D}) where {SC,M,D}
    (u, _, _) -> ∂u(m, u)
    


end
