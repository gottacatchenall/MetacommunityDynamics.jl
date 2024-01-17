"""
    Melbourne & Hastings (2008)
"""

abstract type RickerStochasticityType end

abstract type DemographicStochasticity <:  RickerStochasticityType end
abstract type DemographicHeterogeneity <: RickerStochasticityType end
abstract type EnvironmentalStochasticity <: RickerStochasticityType end 
abstract type SexDeterminationStochasticity <: RickerStochasticityType end 


struct RickerModel{DS,DH,ES,SS,SP} <: Model{Population,Abundance,SP,Discrete}
    β::Parameter                # Rate of birth poisson process
    m::Parameter                # density independent mortality probabiblity 
    α::Parameter                # adult search rate 
    k_environment::Parameter    # environmental stochasticity shape param
    k_dem_hetero::Parameter     # demo heterogeneity shape param
    z::Parameter                # prob. female
end

const _STOCH_TYPES = [DemographicStochasticity, DemographicHeterogeneity, EnvironmentalStochasticity, SexDeterminationStochasticity]
_get_bitvec(X) = [x ∈ X for x in _STOCH_TYPES]
 

RickerModel{A}(x...) where A = RickerModel{_get_bitvec([A])...,Local}(x...)
RickerModel{A,B}(x...) where {A,B} = begin
    @info "foo"
    RickerModel{_get_bitvec([A,B])...,Local}(x...)
end 
RickerModel{A,B,C}(x...) where {A,B,C} = RickerModel{_get_bitvec([A,B,C])...,Local}(x...)
RickerModel{A,B,C,D}(x...) where {A,B,C,D} = RickerModel{_get_bitvec([A,B,C,D])...,Local}(x...)




initial(::RickerModel) where T = 10f0
numspecies(::RickerModel) = 1

# Poisson Ricker Model (only demographic stochasticity)
function ∂u(::RickerModel{true,false,false,false}, N, θ) 
    N <= 0 && return 0
    β, m, α, _, _, _ = θ
    R = (1-m)*β
    return rand(Poisson(N*R*exp(-α*N)))
end


# Negative Binomial Demographic Ricker Model (demographic stochasticity & heterogeneity)
function ∂u(::RickerModel{true,true,false,false}, N, θ) 
    N <= 0 && return 0
    β, m, α, _, k_d, _ = θ
    R = (1-m)*β
    return rand(NegativeBinomial(N*R*exp(-α*N), k_d*N))
end

# Negative Binomial Environment Ricker Model (demographic stochasticity & environmental stochasticity)
function ∂u(::RickerModel{true,false,true,false}, N, θ) 
    N <= 0 && return 0
    β, m, α, kₑ, _, _ = θ
    R = (1-m)*β
    return rand(NegativeBinomial(N*R*exp(-α*N), kₑ))
end

# Poisson-binomial Ricker Model (demographic stochastic and stochastic sex determination)
function ∂u(::RickerModel{true,false,false,true}, N, θ) 
    N <= 0 && return 0
    β, m, α, _, _, z = θ

    F = rand(Binomial(N, z))
    R = (1-m)*β
    return rand(Poisson(F*R*exp(-α*N)))
end

# Negative-Binomial Bionomial Environmental Ricker (demographic stoch,
# stochastic sex determ, environmental stochcasticity)
function ∂u(::RickerModel{true,false,true,true}, N, θ) 
    N <= 0 && return 0
    β, m, α, kₑ, _, z = θ

    F = rand(Binomial(N, z))
    R = (1-m)*β
    return rand(NegativeBinomial(F*R*exp(-α*N), kₑ))
end


# Negative-Binomial Bionomial Demographic Ricker (demographic stoch,
# stochastic sex determ, demographic heterogeneity)
function ∂u(::RickerModel{true,true,false,true}, N, θ) 
    N <= 0 && return 0
    β, m, α, _, k_d, z = θ

    F = rand(Binomial(N, z))
    R = (1-m)*β
    return rand(NegativeBinomial(F*R*exp(-α*N), k_d*N))
end


