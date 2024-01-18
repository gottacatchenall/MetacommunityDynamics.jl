"""
    Scale

Abstract type that is a supertype for all model scales: [`Population`](@ref),
[`Metapopulation`](@ref), [`Community`](@ref), and [`Metacommunity`](@ref). A
model's scale is what it was _orginally_ defined as. For example,
[`TrophicLotkaVolterra`](@ref) is a [`Community`](@ref) model, regardless of
whether is has been convert to run on a spatial-graph via [`spatialize`](@ref).
"""
abstract type Scale end 

"""
    Population

The population scale refers to models that describe the population dynamics of a
single species at a single local location.
"""
abstract type Population <: Scale end
abstract type Metapopulation <: Scale end
abstract type Community <: Scale end
abstract type Metacommunity <: Scale end 

"""
    Measurement

The Measurement abstract type is a supertype for the different types of
_measurements_ a model describes, primarily [`Biomass`](@ref): a continuous
value representing relative amount of mass per species, [`Abundance`](@ref): an
integer valued count of individuals, and [`Occupancy`](@ref): a binary value of
whether is species is present at a location at a given time. 
"""
abstract type Measurement end
abstract type Biomass <: Measurement end
abstract type Abundance <: Measurement end 
abstract type Occupancy <: Measurement end 

"""
    Discreteness


"""
abstract type Discreteness end 
abstract type Discrete <: Discreteness end 
abstract type Continuous <: Discreteness end 


abstract type Stochasticity end 
abstract type Stochastic <: Stochasticity end 
abstract type Deterministic <: Stochasticity end 

abstract type Spatialness end 
abstract type Local <: Spatialness end 
abstract type Spatial <: Spatialness end 
