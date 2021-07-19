struct Biomass{V} <: Measurement
    val::V
end


Base.rand(::Type{Biomass}, names::Vector{Symbol}, dist::Distribution, x::Int, y::Int) = begin
    dict = Dict()

    for name in names
        dict[name] = rand(Biomass, dist, x,y);
    end
    return dict
end



Base.rand(::Type{Biomass}, x::Int,y ::Int) = Base.rand(Biomass, 0.5, x, y)
Base.rand(::Type{Biomass}, dist::Distribution, x::Int, y::Int) = begin
    z = zeros(Biomass, x,y)
    for i in eachindex(z)
        z[i] = rand(dist)
    end
    return z
end

Base.zero(::Biomass{T}) where {T} = Biomass{T}(zero(T))
Base.zero(::Type{Biomass}) = Biomass{Float64}(0)
Base.zero(::Type{<:Biomass{T}}) where {T} = Biomass(zero(T))

Base.zero(::NamedTuple{T,V}) where {T,V <: Tuple{Biomass}} = Biomass{Float32(0.)}


Base.show(io::IO, t::Biomass{T}) where {T} = Base.show(io, T(t.val))

Base.convert(::Type{Biomass}, v::V) where {V <: Number} = Biomass{V}(v)

Base.isless(a::Biomass, b::Biomass) = isless(a.val, b.val)
Base.isless(a::Number, b::Biomass) = isless(a, b.val)
Base.isless(a::Biomass, b::Number) = isless(a.val, b)


Base.oneunit(::Type{<:Biomass{T}}) where {T} = Biomass(one(T))
Base.one(::Type{<:Biomass{T}}) where {T} = Biomass(one(T))
Base.one(::Biomass{T}) where {T} = Biomass{T}(one(T))

Base.:*(x::Biomass, v::Number) = Biomass(x.val * v)
Base.:*(v::Number, x::Biomass) = Biomass(x.val * v)

Base.:/(x::Biomass, v::Biomass) = Biomass(x.val / v.val)
Base.:/(x::Biomass, v::Number) = Biomass(x.val / v)
Base.:/(x::Number, v::Biomass) = Biomass(x / v.val)

Base.:+(x1::Number, x2::Biomass) = Biomass(x1 + x2.val)
Base.:+(x1::Biomass, x2::Number) = Biomass(x1.val + x2)

Base.:-(x1::Number, x2::Biomass) = Biomass(x1 - x2.val)
Base.:-(x1::Biomass, x2::Number) = Biomass(x1.val - x2)

Base.:^(x1::Biomass, x2::Number) = x1.val^x2
Base.:^(x1::Number, x2::Biomass) = x1^x2.val

Base.convert(::Type{Float64}, t::Biomass) = Float64(t.val)

Base.:+(x1::Biomass, x2::Biomass) = Biomass(x1.val + x2.val)
Base.:-(x1::Biomass, x2::Biomass) = Biomass(x1.val - x2.val)
Base.:*(v::Biomass, x::Biomass) = Biomass(x.val * v.val)



DynamicGrids.to_rgb(a::Any, v::Biomass) = DynamicGrids.to_rgb(a, v.val)