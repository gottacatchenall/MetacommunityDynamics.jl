"""
    struct RosenzweigMacArthur{S,T<:Number} <: Model


Dynamics given by

``\\frac{dR}{dt} = \\lambda R \\bigg(1 - \\frac{R}{K}\\bigg) - \\frac{\\alpha CR}{1 +\\alpha \\eta R}``

``\\frac{dC}{dt} = \\beta \\frac{\\alpha CR}{1 + \\alpha \\eta R} - \\gamma   C``

"""
struct RosenzweigMacArthur{S<:Spatialness} <: Model{Community,Biomass,S,Continuous}
    metaweb::Parameter        # metaweb, not a parameter of inference
    λ::Parameter       # λ[i] max instaneous growth rate of i
    α::Parameter              # α[i,j] = attack rate of i on j
    η::Parameter              # η[i, j] =  handling rate of i on j
    β::Parameter              # β[i, j] = growth in i eating j
    γ::Parameter       # heterotroph death rate (0 for all autotrophs)
    K::Parameter       # autotroph carrying capacity (0 for heterotrophs)
end 

# No longer necessary with this as parameter to model type
# discreteness(::RosenzweigMacArthur) = Continuous 

initial(::RosenzweigMacArthur) = [0.2, 0.2]  # note this is only valid for the default params

numspecies(rm::RosenzweigMacArthur) = length(rm.K)


function du_dt(C,R,λ,α,η,β,γ,K)
    @fastmath dR = λ*R*(1-(R/K)) - (α*R*C)/(1+α*η*R)
    @fastmath dC = (β*C*R*α)/(1+α*η*R) - γ*C
    dC,dR
end

function ∂u(rm::RosenzweigMacArthur{Local}, u, θ)
    M, λ, α, η, β, γ, K = θ

    I = findall(!iszero, M)
    du = similar(u)
    du .= 0
    for i in I
        ci,ri = i[1], i[2]
        C,R = u[ci], u[ri]
        λᵢ, αᵢ, ηᵢ, βᵢ, γᵢ, Kᵢ = λ[ri], α[ci,ri], η[ci,ri], β[ci,ri], γ[ci], K[ri]
        dC, dR = du_dt(C,R, λᵢ, αᵢ, ηᵢ, βᵢ, γᵢ, Kᵢ)
        du[ci] += dC
        du[ri] += dR
    end 
    du      
end


# ====================================================
#
#   Constructors
#
# =====================================================

function RosenzweigMacArthur(;
    metaweb = [0 1; 0 0],
    λ =  [0.0, 0.5],   
    α =  [0.0  5.0;    
          5.0  0.0],
    η =  [0.0  3.0;   
          3.0  0.0],
    β =  [0.0  0.5; 
          0.5  0.0],
    γ =  [0.1, 0.],  
    K =  [0.0, 0.3]
)
    RosenzweigMacArthur{Local}(
        Parameter(metaweb), 
        Parameter(λ), 
        Parameter(α), 
        Parameter(η), 
        Parameter(β), 
        Parameter(γ), 
        Parameter(K)
    )
end

# ====================================================
#
#   Spatial, soon we will delete this and have generic method for any spatial
#   model that cycles over locations and runs the local version of this model
#
# =====================================================

function ∂u_spatial(rm::RosenzweigMacArthur, u, θ)
    M = rm.M
    λ, α, η, β, γ, K = θ
    I = findall(!iszero, M)
    du = similar(u)
    du .= 0

    n_sites = size(u,2)
    for site in 1:n_sites
        for i in I
            ci,ri = i[1], i[2]
            C,R = u[ci,site], u[ri,site]
            if C > 0 && R > 0
                λᵢ, αᵢ, ηᵢ, βᵢ, γᵢ, Kᵢ = λ[ri,site], α[ci,ri], η[ci,ri], β[ci,ri], γ[ci], K[ri]
                dC, dR = du_dt(C,R, λᵢ, αᵢ, ηᵢ, βᵢ, γᵢ, Kᵢ)
                du[ci,site] += dC
                du[ri,site] += dR
            end 
        end 
    end
    du 
end

function two_species(::Type{RosenzweigMacArthur}; 
    λ = 0.5, 
    α = 5.0 ,
    η = 3.0,
    β = 0.5,
    γ = 0.1,
    K = 0.3)
    (    
        λ = [0., λ],
        α =  [0.0  α;  
            0.0  0.0],
        η =  [0.0  η;    
            0.0 0.0],
        β =  [0.0  β;   
            0.0  0.0],
        γ =  [γ, 0.],         
        K =  [0.0, K]
    )   
end


function replplot(::RosenzweigMacArthur{Local}, traj::Trajectory) 
    u = timeseries(traj)
    ymax = max([extrema(x)[2] for x in timeseries(traj)]...)
    ts(s) = [mean(u[t][s,:]) for t in 1:length(traj)]
    p = lineplot( ts(1), 
        xlabel="time (t)", 
        ylabel="Biomass", 
        width=80,
        ylim=(0,ymax))

    for i in 2:length(u[1])
        lineplot!(p, ts(i))
    end 
    p
end

function replplot(::RosenzweigMacArthur{Spatial}, traj::Trajectory) 
    u = Array(traj.sol)    
    n_species, n_locations, n_timesteps = size(u)
    ymax = max(u...)

    
    p = lineplot(u[1,1,:], 
        xlabel="time (t)", 
        ylabel="Biomass", 
        width=80,
        ylim=(0,ymax))
         
    cols = n_species < 7 ? [:blue, :red, :green, :orange, :pink, :red] : fill(:dodgerblue, n_species)
    for s in eachslice(u, dims=(2))
        for sp in 1:n_species
            lineplot!(p, s[sp,:], color=cols[sp])
        end
    end 
    p
end



@testitem "Rosenzweig-MacArthur constructor works" begin
    @test typeof(RosenzweigMacArthur()) <: Model
    @test typeof(RosenzweigMacArthur()) <: RosenzweigMacArthur
end




#=


u0 = [0.2,0.2]
foo= factory(RosenzweigMacArthur())
foo(u0,nothing,nothing)


prob = ODEProblem(foo, u0,  (0,100.), ())
@time sol = solve(prob, saveat=(0:1:100));

sol.u


ts(sol, s) = [sum(sol.u[t][s,:]) for t in 1:length(sol.t)]
p = lineplot(ts(sol, 1), 
    xlabel="time (t)", 
    ylabel="Abundance", 
    width=80)
lineplot!(p,ts(sol,2))
p 

f


using DifferentialEquations
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