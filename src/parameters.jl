
sp = SpeciesPool()

sp.traits


#=

    A given model `M` is associated with a set of parameters in that model, `θ`.

    For a given species pool `S`, each species has a set of traits.

    For a spatial graph G, each location in the graph Gⱼ is associated with a
    list of named environment covariates Eⱼ.

    For a given species Sᵢ and its set of traits Tᵢ, each model should provide
    a `niche` function that maps Tᵢ to a new set of parameters associated with
    that species, θᵢⱼ.

    niche(Tᵢ, Eⱼ) -> θᵢ.

    
    Each model `M` must be explicit about what the names of the required
    environmental covariates and traits required are. 

=#




"""
    Trait

"""
struct Trait{S<:Union{String,Symbol},T}
    name::S
    value::T
end

SpeciesPool()


abstract type ParameterType end 

abstract type SpatialVariableness <: ParameterType end 
abstract type SpeciesRelation <: ParameterType end 

abstract type SpatiallyVariable <: SpatialVariableness end 
abstract type SpatiallyConstant <: SpatialVariableness end 
abstract type NotSpatial <: SpatialVariableness end  

abstract type SpeciesSpecific <: SpeciesRelation end 
abstract type Pairwise <: SpeciesRelation end 

storagetype(::Type{SpatiallyVariable}, ::Type{SpeciesSpecific}) = Matrix
storagetype(::Type{SpatiallyVariable}, ::Type{Pairwise}) = Vector{Matrix}

storagetype(::Type{SpatiallyConstant}, ::Type{SpeciesSpecific}) = Vector
storagetype(::Type{SpatiallyConstant}, ::Type{Pairwise}) = Matrix



"""
    Parameter

Yet-another Parameter struct. 
"""

struct Parameter{V<:SpatialVariableness,S<:SpeciesRelation,T} 
    a::T
end 
