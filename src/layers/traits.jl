struct StaticTraitLayer end

struct Trait{V} <: Measurement
    val::V
end

Base.rand(::Type{Trait}, x::Int, y::Int) = Base.rand(Trait, 0.5, x, y)
Base.rand(::Type{Trait}, dist::Distribution, x::Int, y::Int) = begin
    z = zeros(Trait, x, y)
    for i in eachindex(z)
        z[i] = rand(dist)
    end
    return z
end


Base.zero(::Trait{T}) where {T} = Trait{T}(zero(T))
Base.zero(::Type{Trait}) = Trait{Float64}(0)
Base.zero(::Type{<:Trait{T}}) where {T} = Trait(zero(T))


Base.fill(Trait, v, dims) = Base.fill(Trait(v), dims...)
