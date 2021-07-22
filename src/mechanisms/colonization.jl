abstract type Colonization{R,W} <: SetCellRule{R,W} end

struct RandomColonization{R,W,C} <: Colonization{R,W}
    probability::C
end
function RandomColonization{R,W}(; probability=0.1,) where {R,W}
    RandomColonization{R,W}(probability)
end
function DynamicGrids.applyrule!(data, rule::RandomColonization{R,W}, N, I) where {R,W}
    # potentially type asset N is occupancy, later
    N > zero(N) || return zero(N)
    rand() < rule.probability && return one(N)
    return zero(N)
end

"""
    TODO 
"""
struct SpatiallyExplicitLevinsColonization{R,W,C} <: Colonization{R,W}
    probability::C
end
function SpatiallyExplicitLevinsColonization{R,W}(; probability=0.1,) where {R,W}
    SpatiallyExplicitLevinsColonization{R,W}(probability)
end
function DynamicGrids.applyrule!(data, rule::SpatiallyExplicitLevinsColonization{R,W}, N, I) where {R,W}
    # potentially type asset N is occupancy, later
    N > zero(N) || return zero(N)
    rand() < rule.probability && return one(N)
    return zero(N)
end



struct LevinsColonization{R,W,C} <: Colonization{R,W}
    probability::C
end
function LevinsColonization{R,W}(; probability=0.1,) where {R,W}
    LevinsColonization{R,W}(probability)
end
function DynamicGrids.applyrule!(data, rule::LevinsColonization{R,W}, O, I) where {R,W}
    # potentially type asset N is occupancy, later
    O > zero(O) || return zero(O)

    p = sum(data[:O])/size(data[:O])
    c = rule.probability


    rand() < c*p*(1-p) && return one(O)
    return zero(O)
end
