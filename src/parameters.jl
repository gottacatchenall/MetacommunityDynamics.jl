
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

struct Parameter{T<:Number,A<:Union{Array{T,1},Array{T,2}},V<:Union{A,Vector{A}}} 
    value::V
end 

parameters(model::Model) = [getfield(getfield(model, f), :value) for f in fieldnames(typeof(model))]
 
paramdict(model::M) where M<:Model = Dict(zip(fieldnames(M), parameters(model)))

