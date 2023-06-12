"""
abstract type Measurement end

"""
abstract type Measurement end

abstract type Occupancy <: Measurement end 
abstract type Abundance <: Measurement end 
abstract type Biomass <: Measurement end 



struct SpeciesPool
    names 
    traits     
end






# Thompson et al 2020:
# 
# - Density independent growth
# - Density dependent interactions
# - Dispersal 

"""
Mechanism

Must return a function which maps state, parameter (xₜ, θ) pairs to either:
    - dx values for continuous models
    - xₜ₊₁ values for discrete models
"""
abstract type Mechanism{T<:Measurement} end

# These are for Abundance/Biomass

abstract type Growth{T<:Measurement} <: Mechanism{T} end
abstract type Interactions{T<:Measurement} <: Mechanism{T} end
abstract type Dispersal{T<:Measurement} <: Mechanism{T} end

abstract type Drift{T<:Measurement} <: Mechanism{T} end 

abstract type Competition <: Interactions end

abstract type Trophic <: Interactions end













# These are for Occupancy
abstract type Colonization{T<:Measurement} <: Mechanism{T} end
abstract type Extinction{T<:Measurement} <: Mechanism{T} end





""" 
    Trajectory

    A model output with a measurment type
"""
struct Trajectory{T<:Measurement} 
    space 
    output
end 



"""
Option One
--------------------

struct SpatialGraph
    patch -> should patch be its own type?
    env -> should this be a matrix?
end

struct Patch
    coord -> should coord have its own type?
end
"""

"""
Option Two
--------------------

struct SpatialGraph
    patch -> should this be its own type
end

struct Patch
    coord -> 
    env -> downside of having this here is checking same size is more annoying
end
"""