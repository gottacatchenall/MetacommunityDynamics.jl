"""
    RickerStochasticityType


"""
abstract type RickerStochasticityType end

abstract type DemographicStochasticity <:  RickerStochasticityType end
abstract type DemographicHeterogeneity <: RickerStochasticityType end
abstract type EnvironmentalStochasticity <: RickerStochasticityType end 
abstract type SexDeterminationStochasticity <: RickerStochasticityType end 


"""
    RickerModel


"""
struct RickerModel{DS,DH,ES,SS,SP} <: Model{Population,Abundance,SP,Discrete}
    β::Parameter                # Rate of birth Poisson process
    m::Parameter                # density independent mortality probabiblity 
    α::Parameter                # adult search rate 
    k_environment::Parameter    # environmental stochasticity shape param
    k_dem_hetero::Parameter     # demo heterogeneity shape param
    z::Parameter                # prob. female
end

const _STOCH_TYPES = [DemographicStochasticity, DemographicHeterogeneity, EnvironmentalStochasticity, SexDeterminationStochasticity]

_get_bitvec(X) = [x ∈ X for x in _STOCH_TYPES] 
_get_stochasticity_types(X::T) where T<:Vector{<:DataType} = _get_bitvec(X)
_get_stochasticity_types(X::T) where T<:Vector{<:Bool} = _STOCH_TYPES[X]
_get_stochasticity_types(::T) where T<:RickerModel = _STOCH_TYPES[[x for x in T.parameters[1:4]]]

# These are based on empirical fit values from Melbourne and Hastings (2008).
# They don't estimate this directly, they estimate R₀ = β(1-m) for models w/o
# sex-stochasticity, and R₀ = Fₜβ(1-m), where Fₜ ~ Binomial(Nₜ, z) for models
# w/ sex-stochasticity 
# TODO: make these consts
_DEFAULT_kd_both = 0.26
_DEFAULT_kd_solo = 0.01    # the smaller this is, the longer mean time to extinciton is 
_DEFAULT_ke_both = 29.2
_DEFAULT_ke_solo = 1.99
_DEFAULT_R₀ = 2.5
_DEFAULT_α = 0.003  
_DEFAULT_β = 3.0
_DEFAULT_m = 1 - (_DEFAULT_R₀ / _DEFAULT_β)
_DEFAULT_z = 0.5

function _default_ke(rm) 
    stoch_types = _get_stochasticity_types(rm)
    DemographicHeterogeneity ∈ stoch_types && EnvironmentalStochasticity ∈ stoch_types && return _DEFAULT_ke_both
    return _DEFAULT_ke_solo
end 

function _default_kd(rm) 
    stoch_types = _get_stochasticity_types(rm)
    DemographicHeterogeneity ∈ stoch_types && EnvironmentalStochasticity ∈ stoch_types && return _DEFAULT_kd_both
    return _DEFAULT_kd_solo
end 


# this should dispatch all different
_default_parameters(stoch_types) = (
    β = Parameter(_DEFAULT_β), 
    m = Parameter(_DEFAULT_m),
    α = Parameter(_DEFAULT_α),  
    k_environment = Parameter(_default_ke(stoch_types)),
    k_dem_hetero = Parameter(_default_kd(stoch_types)),
    z = Parameter(_DEFAULT_z) 
) 


RickerModel{A}() where A = RickerModel{_get_bitvec([A])...,Local}(_default_parameters(_get_stochasticity_types([A]))...)
RickerModel{A,B}() where {A,B} = RickerModel{_get_bitvec([A,B])...,Local}(_default_parameters(_get_stochasticity_types([A,B]))...)
RickerModel{A,B,C}() where {A,B,C} = RickerModel{_get_bitvec([A,B,C])...,Local}(_default_parameters(_get_stochasticity_types([A,B,C]))...)
RickerModel{A,B,C,D}() where {A,B,C,D} = RickerModel{_get_bitvec([A,B,C,D])...,Local}(_default_parameters(_get_stochasticity_types([A,B,C,D]))...)


_convert_to_nb_parameterization(β) = 1/(1+β)

initial(::RickerModel) = 100.
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

    n = N*R*exp(-α*N)
    fail_odds = k_d*N
    p = _convert_to_nb_parameterization(fail_odds)
    return rand(NegativeBinomial(n,p))
end

# Negative Binomial Environment Ricker Model (demographic stochasticity & environmental stochasticity)
function ∂u(::RickerModel{true,false,true,false}, N, θ) 
    N <= 0 && return 0
    β, m, α, kₑ, _, _ = θ
    R = (1-m)*β

    n = N*R*exp(-α*N)
    fail_odds = kₑ
    p = _convert_to_nb_parameterization(fail_odds)
    return rand(NegativeBinomial(n,p))
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

    # NOTE: this is the fail-odds ratio param of NB
    n = F*R*exp(-α*N)
    fail_odds = kₑ
    p = _convert_to_nb_parameterization(fail_odds)
    return rand(NegativeBinomial(n,p))
end


# Negative-Binomial Bionomial Demographic Ricker (demographic stoch,
# stochastic sex determ, demographic heterogeneity)
function ∂u(::RickerModel{true,true,false,true}, N, θ) 
    N <= 0 && return 0
    β, m, α, _, k_d, z = θ

    F = rand(Binomial(N, z))
    R = (1-m)*β

    n = F*R*exp(-α*N)
    fail_odds = k_d*N
    p = _convert_to_nb_parameterization(fail_odds)
    return rand(NegativeBinomial(n,p))
end


# Negative-Binomial-Gamma (demographic stoch, demographic heterogeneity,
# environment stochasticity)
# it's a gamma mixture of negative binomials
# again the pdf has a nasty infinite integral. shart!
function ∂u(::RickerModel{true,true,true,false}, N, θ) 
    N <= 0 && return 0
    β, m, α, k_e, k_d, _ = θ
    throw("Ricker Model with both environmental stochasticity and demographic heterogeneity has a real motherfucker of a PMF and doesn't fit nicely into a preexisting distribution, so it's not implemented yet :(")
end


# Negative-Binomial Binomial Gamma
# The kitchen sink (demographic stoch, sex stoch, env stoch, dem heterogeneity)
# This doesn't clean up as a nice distribution, its got an unbounded integral,
# its a total mess.
function ∂u(::RickerModel{true,true,true,true}, N, θ) 
    N <= 0 && return 0
    β, m, α, k_e, k_d, z = θ

    throw("Ricker Model with all sources of stochasticity has a real motherfucker of a PMF and doesn't fit nicely into a preexisting distribution, so it's not implemented yet :(")
end




