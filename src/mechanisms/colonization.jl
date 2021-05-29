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

Base.rand(::Type{Occupancy}, x::Int,y ::Int) = Base.rand(Occupancy, 0.5, x, y)
Base.rand(::Type{Occupancy}, p::Float64, x::Int,y ::Int) = begin
    z = zeros(Occupancy, x,y)
    for i in eachindex(z) 
        z[i] = rand() < p
    end 
    return z
end
