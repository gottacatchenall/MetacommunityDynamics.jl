"""
    BevertonHolt <: Model

The [Beverton-Holt
model](https://en.wikipedia.org/wiki/Beverton%E2%80%93Holt_model) is a
discrete-time, deterministic model of population dynamics. It is commonly
interpreted as a discrete-time version of the logistic model.

It is described by 

``N_{t+1} =\\frac{R_0 M}{N_t + M}N_t``

where ``K = (R\\_0 - 1)M`` is the carrying capacity.

"""
struct BevertonHolt{S,F<:Number} <: Model{Population,Biomass,S,Discrete}
    R₀::F
    K::F 
end 
initial(bm::BevertonHolt) = 7.  # note this is only valid for the default params

discreteness(::BevertonHolt) = Discrete

"""
    ∂u(bm::BevertonHolt, x)

Single time-step for the `BevertonHolt` model. 
"""
function ∂u(bm::BevertonHolt{T}, x::T) where {T<:Number}
    R₀, K =  bm.R₀, bm.K

    @fastmath M = K/(R₀-1)
    @fastmath R₀ * x / (1 + (x/M))
end 


# ====================================================
#
#   Constructors
#
# =====================================================

function BevertonHolt()
    R₀, K = 1.2, 50.
    BevertonHolt{Local,Float64}(R₀, K)
end


function replplot(::BevertonHolt, traj)
    u = timeseries(traj)
    ymax = max(u...)
    p = lineplot(u, 
        xlabel="time (t)", 
        ylabel="Abundance", 
        width=80,
        ylim=(0,ymax))
    p
end

@testitem "Beverton-Holt constructor works" begin
    @test typeof(BevertonHolt()) <: Model
    @test typeof(BevertonHolt()) <: BevertonHolt
end
