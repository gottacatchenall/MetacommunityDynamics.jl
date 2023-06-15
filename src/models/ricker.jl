"""
    Melbourne & Hastings 
"""

abstract type RickerStochasticityType end

abstract type DemographicStochasticity <:  RickerStochasticityType end
abstract type DemographicHeterogeneity <: RickerStochasticityType end
abstract type EnvironmentalStochasticity <: RickerStochasticityType end 
abstract type SexStochasticity <: RickerStochasticityType end 



struct RickerParams{T}

end

struct RickerModel{T<:RickerStochasticityType}
    params::RickerParams{T}
end

