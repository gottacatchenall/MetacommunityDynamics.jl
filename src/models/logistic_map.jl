"""
    LogisticMap{S} <: Model{Population,Biomass,S,Continuous}

Logistic Map. 
"""
struct LogisticMap{S} <: Model{Population,Biomass,S,Discrete}
    r::Parameter
    K::Parameter
end 

discreteness(::LogisticMap{T}) where T = MetacommunityDynamics.Discrete 
initial(::LogisticMap{T}) where T = 0.3
numspecies(::LogisticMap) = 1


function ∂u(::LogisticMap, u, θ)
    rs, Ks = θ
    N = u[1]
    N <= 0 && return 0
    r, K = rs[1], Ks[1]
    return @fastmath r*N*(1-(N/K))
end


# ====================================================
#
#   Constructors
#
# =====================================================

function LogisticMap(;
    r::T = 1.8,
    K::T = 1.,
) where {T<:Number}
    LogisticMap{Local}(
        Parameter(r), 
        Parameter(K))
end

