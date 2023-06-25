abstract type Scale end 

abstract type Population <: Scale end
abstract type Metapopulation <: Scale end
abstract type Community <: Scale end
abstract type Metacommunity <: Scale end 


abstract type Measurement end
abstract type Biomass <: Measurement end
abstract type Abundance <: Measurement end 
abstract type Occupancy <: Measurement end 


abstract type Discreteness end 
abstract type Discrete <: Discreteness end 
abstract type Continuous <: Discreteness end 


abstract type Stochasticity end 
abstract type Stochastic <: Stochasticity end 
abstract type Deterministic <: Stochasticity end 

abstract type Spatialness end 
abstract type Local <: Spatialness end 
abstract type Spatial <: Spatialness end 
