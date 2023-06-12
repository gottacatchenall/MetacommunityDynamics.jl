
"""
    SpeciesPool{T<:Number}

A `SpeciesPool` consists of a set of species and their corresponding traits. 
"""
@kwdef struct SpeciesPool{T<:Number}
    species =  [Symbol("s$i") for i in 1:5]
    traits::Dict{Symbol, Vector{T}} = Dict(:x=>rand(length(species)))
end

# ====================================================
#
#   Constructors
#
# =====================================================

Base.getindex(sp::SpeciesPool, i::I) where I<:Integer = sp.species[i]
Base.string(sp::SpeciesPool) = """A {#e691c1}{bold}species pool{/bold}{/#e691c1} with {bold}{blue}$(length(sp.species)){/blue}{/bold} species."""
Base.show(io::IO, ::MIME"text/plain", sp::SpeciesPool) = begin 
    tprint(io, string(sp))
end


Base.size(sp::SpeciesPool) = length(sp.species)
Base.length(sp::SpeciesPool) = size(sp)


struct Species{T<:Number}
    traits::Dict{Symbol, T}
end 