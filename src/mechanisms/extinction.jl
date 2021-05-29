abstract type Extinction{R,W} <: CellRule{R,W} end 

struct RandomExtinction{R,W,C} <: Extinction{R,W}
    probability::C
end
function RandomExtinction{R,W}(; probability=0.1,) where {R,W}
    RandomExtinction{R,W}(probability)
end

function DynamicGrids.applyrule(data, rule::RandomExtinction, N, I)
    N> zero(N) || return zero(N)
    rand() < rule.probability && return one(N)
    return zero(N)
end
