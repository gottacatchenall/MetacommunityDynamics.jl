
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

function parameters(model::T) where T<:Model 
    θ = []
    for f in fieldnames(T)
        field = getfield(model, f)
        typeof(field) <: Parameter && push!(θ, getfield(field, :value))
    end
    θ
end
paramdict(model::M) where M<:Model = Dict(zip(fieldnames(M), parameters(model)))

