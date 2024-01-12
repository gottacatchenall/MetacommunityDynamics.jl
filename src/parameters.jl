const _PARAM_TYPES = Union{Array{T,N},T} where {T,N}

"""
    Parameter{T<:Number,A<:Union{Array{T,1},Array{T,2}},V<:Union{A,Vector{A}}} 

Yet-another Parameter struct. 
"""
struct Parameter{T,N} 
    value::_PARAM_TYPES
end 
Parameter(x) = Parameter{typeof(x),typeof(x)<:Number ? Nothing : size(x,1)}(x)

dimension(::Parameter{T,N}) where {T,N} = N
isscalar(p::Parameter) = dimension(p) == Nothing
value(p::Parameter) = p.value 
Base.size(p::Parameter{T,N}, n) where {T,N} = size(value(p), n)
Base.length(p::Parameter{T,N}) where {T,N} = N == 1 ? 1 : size(p,1) 



function parameters(model::T) where T<:Model 
    θ = ()
    for f in fieldnames(T)
        field = getfield(model, f)
        if typeof(field) <: Parameter
            θ =(θ...,  getfield(field, :value))
        end 
    end
    θ
end
paramdict(model::M) where M<:Model = Dict(zip(fieldnames(M), parameters(model)))

