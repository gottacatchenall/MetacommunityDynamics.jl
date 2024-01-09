"""
    LogisticModel{S} <: Model{Population,Biomass,S,Continuous}

Logistic Model. 
"""
struct LogisticModel{S} <: Model{Population,Biomass,S,Continuous}
    λ::Parameter
    K::Parameter
    α::Parameter
end 

discreteness(::LogisticModel{T}) where T = MetacommunityDynamics.Continuous 
initial(::LogisticModel{T}) where T = 5.
numspecies(::LogisticModel) = 1


function ∂u(lm::LogisticModel, u, θ)
    λs, Ks, αs = θ
    N = u[1]
    N <= 0 && return 0
    λ, K, α = λs[1], Ks[1], αs[1] 
    return @fastmath λ*u*(1-(N/K)^α)
end


# ====================================================
#
#   Constructors
#
# =====================================================

function LogisticModel(;
    λ::T = 1.2,
    K::T = 50.,
    α::T  = 1.
) where T 
    LogisticModel{Local}(
        Parameter(λ), 
        Parameter(K), 
        Parameter(α))
end


