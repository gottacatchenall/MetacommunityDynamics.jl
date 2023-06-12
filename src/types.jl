"""
abstract type Measurement end

"""
abstract type Measurement end
abstract type Occupancy <: Measurement end 
abstract type Abundance <: Measurement end 
abstract type Biomass <: Measurement end 


abstract type Scale end 



struct Population <: Scale
    species::Species
end

struct Metapopulation <: Scale
    species::Species
    spatialgraph::SpatialGraph
end

struct Community <: Scale
    species::SpeciesPool
end

struct Metacommunity <: Scale
    spatialgraph::SpatialGraph
    species::SpeciesPool
end 

# Thompson et al 2020:
# 
# - Density independent growth
# - Density dependent interactions
# - Dispersal 

# A mapping from traits x environment to a growth value 
abstract type Niche end

@kwdef struct GaussianNiche <: Niche
    traits = (:λ, :μ, :σ)
    multivariate = false 
end

function (gn::GaussianNiche)(traits, env)
    λ, μ, σ = traits
    @fastmath λ*exp(-(μ - env)^2 /(2σ^2))
end
# Conditions that must be true:
#
# - A species pool must have same trait-dimensions ∀ species


"""
Mechanism

Must return a function which maps state, parameter (xₜ, θ) pairs to either:
    - dx values for continuous models
    - xₜ₊₁ values for discrete models
"""

abstract type Mechanism{S <: Scale, M<:Measurement} end

# These are for Abundance/Biomass

abstract type Growth <: Mechanism end
abstract type Interactions <: Mechanism end
abstract type Dispersal <: Mechanism end
abstract type Drift <: Mechanism end 

abstract type Competition{S,M} <: Interactions{S,M} end
abstract type Trophic{S,M} <: Interactions{S,M} end


# These are for Occupancy
abstract type Colonization{S,M} <: Mechanism{S,M} end
abstract type Extinction{S,M} <: Mechanism{S,M} end

# Maybe mechanism should be struct
# 

mechanism(::Mechanism{S,M}) where {S,M} = M
scale(::Mechanism{S,M}) where {S,M} = S


struct LotkaVolterraCompetition # these parameters are the same across space if meta
    α
    K
end


function f(lvc::LotkaVolterraCompetition, λ, x)
    @info "with so much drama in the lvc..."
    α, K = lvc.α, lvc.K 

    return [xi * λ * (1 - (sum([xi*α[i,j] for j in eachindex(x)]) / K[i])) for (i,xi) in enumerate(x)]
end

lv = LotkaVolterraCompetition(ones(5,5), [1 for i in 1:5])

Species(Dict(:λ=>1.2))

f(lv, 1.2, [0.3, 1.2])




""" 
    Trajectory

    A model output with a measurment type
"""
struct Trajectory{T<:Measurement} 
    space::SpatialGraph 
    output
end 