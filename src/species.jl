

@kwdef struct SpeciesPool{T}
    species =  [Symbol("s$i") for i in 1:5]
    traits::Dict{Symbol, Vector{T}} = Dict(:x=>rand(length(species)))
end

Base.getindex(sp::SpeciesPool, i::I) where I<:Integer = sp.species[i]
Base.string(sp::SpeciesPool) = """A {#e691c1}{bold}species pool{/bold}{/#e691c1} with {bold}{blue}$(length(sp.species)){/blue}{/bold} species."""
Base.show(io::IO, ::MIME"text/plain", sp::SpeciesPool) = begin 
    tprint(io, string(sp))
end 

Base.size(sp::SpeciesPool) = length(sp.species)
Base.length(sp::SpeciesPool) = size(sp)

# A mapping from traits x environment to a growth value 
abstract type Niche end

@kwdef struct GaussianNiche <: Niche
    traits = (:λ, :μ, :σ)
    multivariate = false 
end

function (gn::GaussianNiche)(traits, env)
    λ, μ, σ = traits
    @fastmath λ*exp(-(μ - env)^2 /(2σ^2))
end




# Conditions that must be true:
#
# - A species pool must have same trait-dimensions ∀ species
