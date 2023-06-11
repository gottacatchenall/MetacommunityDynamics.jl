

# To figure out:
# Species, traits, and environments


@kwdef struct Species{T,I<:Integer}
    id::I = 1
    traits::Vector{T} = rand(5)
end
Base.string(species::Species) = """
A {#ffa770}{bold}species{/bold}{/#ffa770} with id {bold}{blue}$(species.id){/blue}{/bold}."""

Base.show(io::IO, ::MIME"text/plain", species::Species) = begin 
    tprint(io, string(species))
end 


@kwdef struct SpeciesPool
    species::Vector{Species} = [Species(id=i) for i in 1:5]
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
