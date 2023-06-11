"""
abstract type Measurement end

"""
abstract type Measurement end

abstract type Occupancy <: Measurement end 
abstract type Abundance <: Measurement end 
abstract type Biomass <: Measurement end 



struct SpeciesPool
    
end

struct Species
    traits
end





# Thompson et al 2020:
# 
# - Density independent growth
# - Density dependent interactions
# - Dispersal 

"""
    Mechanisms

"""
abstract type Mechanism{T<:Measurement} end

# These are for Abundance/Biomass
abstract type Growth{T<:Measurement} <: Mechanism{T} end
abstract type Interactions{T<:Measurement} <: Mechanism{T} end
abstract type Dispersal{T<:Measurement} <: Mechanism{T} end



struct Competition <: Interactions 
    
end


struct Eating <: Interactions

end













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