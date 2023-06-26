
"""
    Trait

"""
struct Trait{S<:Union{String,Symbol},T}
    name::S
    value::T
end

"""
    Parameter

Yet-another Parameter struct. 
"""

struct Parameter{T<:Number,A<:Union{Array{T}, Vector{Array{T}}}} 
    value::A
end 

parameters(model::Model) = [getfield(getfield(model, f), :value) for f in fieldnames(typeof(model))]
 
