"""
    Model{SC<:Scale,M<:Measurement,SP<:Spatialness,D<:Discreteness}

The abstract type from all models in MetacommunityDynamics. All `Model`'s are
parametric types that stores four parameters that describe the model: [`Scale`],
[`Measurement`], [`Spatialness`], and [`Discreteness`]. 


# TODO: 
# change abstract types -> traits,

`spatialness(t::Model) = Local()`
`spatialness(t::Model) = Spatial()`
"""
abstract type Model{SC<:Scale,M<:Measurement,SP<:Spatialness,D<:Discreteness} end 

Base.string(m::Model{SC,M,SP,D}) where {SC,M,SP,D} = "{blue}$SP{/blue} {bold}$(typeof(m)){/bold}"

Base.show(io::IO, m::Model) = begin 
    tprint(io, m)
end 

#TODO: this is Holy Traits design pattern, but reimplented in a worse way
scale(::Model{SC,M,SP,D}) where {M,SC,SP,D} = SC
discreteness(::Model{SC,M,SP,D}) where {M,SC,SP,D} = D
spatialness(::Model{SC,M,SP,D}) where {M,SC,SP,D} = SP
measurement(::Model{SC,M,SP,D}) where {M,SC,SP,D} = M
