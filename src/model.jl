abstract type Model{SC<:Scale,M<:Measurement,SP<:Spatialness,D<:Discreteness} end 

scale(::Model{SC,M,SP,D}) where {M,SC,SP,D} = SC
discreteness(::Model{SC,M,SP,D}) where {M,SC,SP,D} = D
spatialness(::Model{SC,M,SP,D}) where {M,SC,SP,D} = SP
measurement(::Model{SC,M,SP,D}) where {M,SC,SP,D} = M
