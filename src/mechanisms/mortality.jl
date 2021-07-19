abstract type Mortality{R,W} <: CellRule{R,W} end


struct LinearMortality{R,W,D,T} <: Mortality{R,W}
    proportion::D
    threshold::T
end 
LinearMortality{R,W}(d::D; threshold::T=0.01) where {R,W,D,T} = LinearMortality{R,W}(d,threshold)

function DynamicGrids.applyrule(data, rule::LinearMortality,N, I)
    # potentially type asset N is occupancy, later
    N > zero(N) || return zero(N)
    N > rule.threshold || return zero(N)
    new =  @fastmath N - rule.proportion*N
    new > zero(N) && return new
    return zero(N)
end


LinearMortality(layernames::T, decay::DT; threshold::TT=0.01) where {T, DT, TT} = begin
    rules = Ruleset()
    for sym in layernames
        rules += LinearMortality{sym}(decay, threshold=threshold)
    end
    return rules
end
