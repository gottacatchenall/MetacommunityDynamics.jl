abstract type Growth{R,W} <: CellRule{R,W} end


# Basically we can define this around fitness 
# and compute realized λ later 

struct LogisticGrowth{R,W,LT,KT,AT,TT} <: CellRule{R,W}
    fitnessmap::LT
    K::KT
    α::AT
    dt::TT
end
LogisticGrowth{R,W}(;
    λ::LT = 1.5,
    K::KT = 100.0,
    α::AT = 1,
    dt::TT = 0.1,
) where {R,W,LT,KT,AT,TT} = LogisticGrowth{R,W}(λ, K, α, dt)

LogisticGrowth(
    layernames::T;
    λ::LT = 1.5,
    K::KT = 100.0,
    α::AT = 1,
    dt::TT = 0.1,
) where {T<:Vector{Symbol},LT,KT,AT,TT} = begin
    rules = Ruleset()
    for sym in layernames
        rules += LogisticGrowth{sym}(; λ = λ, K = K, α = α, dt = dt)
    end
    return rules
end


#LogisticGrowth(fitfunc::FitnessFunction)


function DynamicGrids.applyrule(data, rule::LogisticGrowth, X, index)
    w = fitness(fitnessmap(rule))

    dx = @fastmath rule.λ * X * (1.0 - (X / rule.K)^rule.α)
    return @fastmath X + dx * rule.dt
end
