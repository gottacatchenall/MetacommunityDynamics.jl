abstract type Extinction{R,W} <: CellRule{R,W} end 

"""
    RandomExtinction
"""
struct RandomExtinction{R,W,C} <: Extinction{R,W}
    probability::C
end
function RandomExtinction{R,W}(; probability::PT=0.1) where {R,W,PT}
    RandomExtinction{R,W,PT}(probability)
end

function RandomExtinction(names::T; probability=0.1)  where {T <: Vector{Symbol}}
    rules = Ruleset()
    for n in names
        rules += RandomExtinction{n}(probability=probability)
    end
    return rules
end


function DynamicGrids.applyrule(data, rule::RandomExtinction, N, I)
    N > zero(N) || return zero(N)
    rand() < rule.probability || return (N)
    return zero(N)
end

"""
    AbioticExtinction
"""
struct AbioticExtinction{R,W,L,C,F} <: Extinction{R,W}
    envlayer::L
    baseprobability::C
    mapping::F
end
function AbioticExtinction{R,W}(envlayer; baseprobability=0.1, mapping=ExponentialFitness()) where {R,W}
    AbioticExtinction{R,W}(baseprobability, envlayer, mapping)
end
function DynamicGrids.applyrule(data, rule::AbioticExtinction, O, I)
    E =  data[rule.envlayer][I...]
    O > zero(O) || return zero(O)
    extinctprob = rule.baseprobability*rule.mapping(E)  # goes to 0 as E goes to infinity with default Expontential Fitness
    rand() < extinctprob && return one(O)
    return zero(O)
end


