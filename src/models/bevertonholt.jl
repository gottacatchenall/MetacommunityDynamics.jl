"""
    BevertonHolt <: Model

The [Beverton-Holt
model](https://en.wikipedia.org/wiki/Beverton%E2%80%93Holt_model) is a
discrete-time, deterministic model of population dynamics. It is commonly
interpreted as a discrete-time version of the logistic model.  
"""
@kwdef struct BevertonHolt{F<:Number} <: Model
    R₀::F = 1.2
    K::F = 50.
end 
initial(bm::BevertonHolt) = 7.  # note this is only valid for the default params

discreteness(::BevertonHolt) = Discrete

"""
    ∂u(bm::BevertonHolt, x)

Single time-step for the `BevertonHolt` model. 
"""
function ∂u(bm::BevertonHolt{T}, x::T) where {T<:Number}
    R₀, K = bm.R₀, bm.K

    @fastmath M = K/(R₀-1)
    @fastmath R₀ * x / (1 + (x/M))
end 


# This could generalize to factory(model::Model{S<:Spatialness})
# and adds ∂x if Spatial
"""
    factory(bh::BevertonHolt)

Model factory for the Beverton-Holt model. Returns a function that takes a state
`u` and returns an anonymous function and returns `du`. 
"""
function factory(bh::BevertonHolt)
    (u,_,_) -> ∂u(bh, u)
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


# factory(BevertonHolt())(5100, "", "")

#=
bh = BevertonHolt()
u0 = 7.
prob = DiscreteProblem(factory(bh), u0, (0,100.), (), saveat=0:100);
@time sol = solve(prob);

=#