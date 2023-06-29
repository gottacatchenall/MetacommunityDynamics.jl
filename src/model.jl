abstract type Model{SC<:Scale,M<:Measurement,SP<:Spatialness,D<:Discreteness} end 

Base.string(m::Model{SC,M,SP,D}) where {SC,M,SP,D} = """
{bold}$(typeof(m)){/bold}
"""

Base.show(io::IO, ::MIME"text/plain", m::Model) = begin 
    tprint(io, string(m))
end 



scale(::Model{SC,M,SP,D}) where {M,SC,SP,D} = SC
discreteness(::Model{SC,M,SP,D}) where {M,SC,SP,D} = D
spatialness(::Model{SC,M,SP,D}) where {M,SC,SP,D} = SP
measurement(::Model{SC,M,SP,D}) where {M,SC,SP,D} = M
