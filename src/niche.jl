abstract type Niche end

@kwdef struct GaussianNiche <: Niche
    traits = (:λ, :μ, :σ)
    multivariate = false 
end

function (gn::GaussianNiche)(traits, env)
    μ, σ = traits
    @fastmath exp(-(μ - env[begin])^2 /(2σ^2))
end
traitnames(gn::GaussianNiche) = (:μ, :σ)
traitdims(::GaussianNiche) = 2
