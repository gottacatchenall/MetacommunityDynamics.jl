
@kwdef struct RosenzweigMacArthur{T<:Number} <: Model 
    # C = 1, R = 2
    λ::Vector{T} =  [0.5, 0.0]
    α::Matrix{T} =  [0.0  5.0;    # α[i,j] = energy flow i eating j
                     0.0  0.0]
    η::Matrix{T} =  [0.0  3.0;    # η[i, j] =  handling rate i eating j
                     0.0  0.0]
    β::Matrix{T} =  [0.0  0.1;    # β[i, j] = growth in i eating j
                     0.0  0.0]
    γ::Vector{T} =  [0.1, 0.]           # heterotroph death rate (0 for all autotrophs)
    K::Vector{T} =  [0.0, 1.0]           # autotroph carrying capacity (0 for heterotrophs)
end 

function dx(rm::RosenzweigMacArthur)
    #λ, α, K = clv.λ, clv.α, clv.K
    function foo(x)
    #    du = similar(x)
    #    for s in axes(x,1)
    #        @fastmath du[s] = x[s] * λ[s] * (1 - (sum([x[t]*α[s,t] for t in 1:size(x,1)]) / K[s]))
    #    end
    #    du
    
    end
    foo 
end

print("foo")


#=using DifferentialEquations
using MetacommunityDynamics
using Distributions


abstract type Scale end  
struct Metacommunity <: Scale
    spatialgraph::SpatialGraph
    species::SpeciesPool
end 

abstract type Model end 

@kwdef struct RosenzweigMacArthur{T<:Number} <: Model 
    λ::Vector{T}
    α::Matrix{T}
    η::Matrix{T}
    β::Matrix{T} 
    γ::Vector{T} 
    K::Vector{T}
end 

RosenzweigMacarthur() = RosenzweigMacarthur(
    
)


# Constraints 

# Any species with positive λ has to have 0s in α,η,δ,β

params(::RosenzweigMacarthur) = Dict(
    :λ => "Resource intrinsic growth rate",
    :α => "Attack rate",
    :η => "Handling rate",
    :β => "Gain of biomass for consumer per unit resource",
    :γ => "Intrinsic consumer death rate",
    :K => "Carrying capacity")


params(RosenzweigMacarthur(1,2,3,4,5,6))
    


function step(::Type{RosenzweigMacarthur}, x::Vector{T}, θ) where T<:Number
    @unpack λ, α, η, β, γ, K = θ

    R, C = x 
    @fastmath dR = λ*R*(1-(R/K)) - (α*R*C)/(1+α*η*R)
    @fastmath dC = (β*C*R*α)/(1+α*η*R) - γ*C
    
    [dR, dC]
end

# spatial version
# λ better be a matrix, K better be a vector 
# 
#
# okay, here's when you use traits to be smart.
# RM should have parametric type assigned based on whether it is 
# spatial or not. 
# 
# Also during construction of a model, the species pool object
# should be checked to determine n_species.

# For many species: αᵢⱼ is a matrix, βᵢⱼ, hᵢᴶ
function step(::Type{RosenzweigMacarthur}, x::Matrix{T}, θ) where T<:Number
    @unpack λ, α, η, β, γ, K = θ
 
    ns = size(u, 2) 


    # TODO: this needs to be generic for N species
    for i in 1:ns
        R = u[1,i[1],i[2]]
        C = u[2,i[1], i[2]]

        du[1,i] = λ*R*(1-(R/K[i])) - (α*R*C)/(1+α*η*R)
        du[2,i] = (β*C*R*α)/(1+α*η*R) - γ*C
    end

    R, C = x 

    @fastmath dR = λ*R*(1-(R/K)) - (α*R*C)/(1+α*η*R)
    @fastmath dC = (β*C*R*α)/(1+α*η*R) - γ*C
    
    [dR, dC]
end


function traits(mc::Metacommunity)
    mc.species.traits
end


function matching(required_traits, provided_traits)
    @info required_traits, provided_traits
end

function instantiate(::Type{RosenzweigMacarthur}, mc::Metacommunity)
    required_traits = fieldnames(params(RosenzweigMacarthur))

    matching(required_traits, traits(mc)) 

    # traits(mc) has to meet several conditions:
    #   - must have same number of params as species for some things
    #   - must have params that are s x s for some things
    #   - might have species x location specific  parameters

    # dispatch required_traits shapes based on Scale
    
    
end


sg = SpatialGraph()
sp = SpeciesPool()

num_species = 5


mc = Metacommunity(sg, sp)



traits(mc)


instantiate(RosenzweigMacarthur, mc)












θ = (λ=1.5, α=3., η=1., β=0.5, γ=0.1,K = 1.)
@time step(RosenzweigMacarthur, (0.4,0.5), θ)

u0 = [0.7, 0.3]

f(x,θ,t) = step(RosenzweigMacarthur, x, θ)

prob = ODEProblem(f, u0,  (0,100.),θ,)

@time sol = solve(prob)

ts(sol, s) = [sum(sol.u[t][s,:]) for t in 1:length(sol.t)]
p = lineplot(ts(sol, 1), 
    xlabel="time (t)", 
    ylabel="Abundance", 
    width=80,
    ylim=(0,1.5))
lineplot!(p, ts(sol, 2))

p

=#