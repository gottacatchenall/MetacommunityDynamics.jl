abstract type Selection{R,W} <: CellRule{R,W} end 


abstract type FitnessFunction end 
struct GaussianFitness{AT} <: FitnessFunction
    α::AT
end 
GaussianFitness(; α = 0.1) = GaussianFitness(α)
(gf::GaussianFitness)(dist::Number) = @fastmath exp(-1*gf.α*dist)

struct DensityDependentFitness{LT, KT,AT} <: FitnessFunction
    λ::LT
    K::KT
    α::AT
end 
DensityDependentFitness(; λ=2, K = 100, α = 1) = DensityDependentFitness(λ, K, α)
(ddf::DensityDependentFitness)(x) = @fastmath ddf.λ*((1.0-(x/ddf.K))^ddf.α)



"""
    Abiotic selection 

    The change in the biotic measurement 
    is a function of both its value, and optionally the value of
    an environmental (abiotic) measurement `v`.

    dx/dt ∝ f(x, v)
"""

struct AbioticSelection{R,W,F} <: Selection{R,W}
    fitness::F
end
function AbioticSelection{R,W}(
    ; fitness::FitnessFunction = GaussianFitness()
) where {R,W}
    AbioticSelection{R,W}(fitness)
end
function DynamicGrids.applyrule(data, rule::AbioticSelection, (X,E), index) 
    w = rule.fitness(X-E)
    return X*w, E
end


"""
    Biotic selection 
 
    The change in the biotic measurement 
    is a function of both its value and the value of
    another biotic measurement `y`, and optionally the value of 
    an environmental measurement.

    biotic measurement `y`, i.e. dx/dt ∝ f(x,y,e)
"""
struct BioticSelection{R,W,F} <: Selection{R,W}
    fitness::F
end
function BioticSelection{R,W}(
    ; fitness::FitnessFunction = GaussianFitness()
) where {R,W}
    BioticSelection{R,W}(fitness)
end
function DynamicGrids.applyrule(data, rule::BioticSelection, (X), index) 
    w = rule.fitness(X)
    return X*w
end
