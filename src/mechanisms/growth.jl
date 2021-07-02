abstract type Growth{R,W} <: CellRule{R,W} end


struct LogisticGrowth{R,W,LT,KT,AT,TT} <: CellRule{R,W}
    λ::LT
    K::KT
    α::AT
    dt::TT
end
LogisticGrowth{R,W}(; λ::LT =1.5, K::KT=100., α::AT=1, dt::TT=0.1) where {R,W,LT, KT, AT, TT} = LogisticGrowth{R,W,LT,KT,AT,TT}(λ, K, α,dt)

function DynamicGrids.applyrule(data, rule::LogisticGrowth, X, index) 
    dx = @fastmath rule.λ * X * (1. - (X/rule.K)^rule.α)
    return @fastmath X + dx*rule.dt
end

