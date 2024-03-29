"""
    BevertonHolt{S} <: Model{Population,Biomass,S,Discrete}

The [Beverton-Holt
model](https://en.wikipedia.org/wiki/Beverton%E2%80%93Holt_model) is a
discrete-time, deterministic model of population dynamics. It is commonly
interpreted as a discrete-time version of the logistic model.

It is described by 

``N_{t+1} =\\frac{R_0 M}{N_t + M}N_t``

where ``K = (R\\_0 - 1)M`` is the carrying capacity.

"""
struct BevertonHolt{S} <: Model{Population,Biomass,S,Discrete}
    R₀::Parameter
    K::Parameter
end 
initial(bm::BevertonHolt) = 7.  # note this is only valid for the default params

"""
    ∂u(bm::BevertonHolt, x)

Single time-step for the `BevertonHolt` model. 
"""
function ∂u(bm::BevertonHolt, x, θ) 
    R₀, K =  θ
    N = x[1]
    N <= 0 && return 0 
    @fastmath M = K[1]/(R₀[1]-1)
    @fastmath R₀[1] * x / (1 + (N/M))
end 


# ====================================================
#
#   Constructors
#
# =====================================================

function BevertonHolt(;
    R₀::T = 1.2,
    K::T = 50.
) where T 
    BevertonHolt{Local}(
        Parameter(R₀),
        Parameter(K))
end

# ====================================================
#
#   Tests
#
# =====================================================

@testitem "Beverton-Holt constructor works" begin
    @test typeof(BevertonHolt()) <: Model
    @test typeof(BevertonHolt()) <: BevertonHolt
end
