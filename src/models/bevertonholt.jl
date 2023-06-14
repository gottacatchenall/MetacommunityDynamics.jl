"""
    BevertonHolt <: Model

The [Beverton-Holt
model](https://en.wikipedia.org/wiki/Beverton%E2%80%93Holt_model) is a
discrete-time, deterministic model of population dynamics. It is commonly
interpreted as a discrete-time version of the logistic model.  
"""
@kwdef struct BevertonHolt <: Model 
    R₀ = 1.2
    K = 50
end 


"""
    ∂u(bm::BevertonHolt, x)

Single time-step for the `BevertonHolt` model. 
"""
function ∂u(bm::BevertonHolt, x)
    R₀, K = bm.R₀, bm.K

    @fastmath M = K/(R₀-1)
    @fastmath R₀ * x / (1 + (x/M))
end 


# This could generalize to model_factory(model::Model{S<:Spatialness})
# and adds ∂x if Spatial
function model_factory(bh::BevertonHolt)
    (x,_,_) -> ∂u(bh, x)
end


@testitem "Beverton-Holt constructor works" begin
    @test typeof(BevertonHolt()) <: Model
    @test typeof(BevertonHolt()) <: BevertonHolt
end



bh = BevertonHolt()
u0 = 7.
prob = DiscreteProblem(model_factory(bh), u0, (0,100.), (), saveat=0:100);
@time sol = solve(prob);

