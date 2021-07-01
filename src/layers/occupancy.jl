struct Occupancy{V} <: Measurement
    val::V
end

Base.rand(::Type{Occupancy}, x::Int,y ::Int) = Base.rand(Occupancy, 0.5, x, y)
Base.rand(::Type{Occupancy}, p::Float64, x::Int,y ::Int) = begin
    z = zeros(Occupancy, x,y)
    for i in eachindex(z)
        z[i] = rand() < p
    end
    return z
end

Float64(t::Occupancy{T}) where {T} = Float64(t.val)

Base.zero(::Occupancy{T}) where {T} = Occupancy{T}(zero(T))
Base.zero(::Type{Occupancy}) = Occupancy{Bool}(false)
Base.zero(::Type{<:Occupancy{T}}) where {T} = Occupancy(zero(T))

Base.show(io::IO, t::Occupancy{T}) where {T} = Base.show(io, T(t.val))

Base.convert(::Type{Occupancy}, v::V) where {V <: Bool} = Occupancy{V}(v)

Base.isless(a::Occupancy, b::Occupancy) = isless(a.val, b.val)
Base.oneunit(::Type{<:Occupancy{T}}) where {T} = Occupancy(one(T))
Base.one(::Type{<:Occupancy{T}}) where {T} = Occupancy(one(T))
Base.one(::Occupancy{T}) where {T} = Occupancy{T}(one(T))

Base.:*(x::Occupancy, v::Number) = Occupancy(x.val * v)
Base.:*(v::Number, x::Occupancy) = Occupancy(x.val * v)
Base.:/(x::Occupancy, v::Number) = Occupancy(x.val / v)
Base.:+(x1::Occupancy, x2::Occupancy) = Occupancy(x1.val & x2.val)
Base.:-(x1::Occupancy, x2::Occupancy) = Occupancy(x1.val & x2.val)
Base.:-(o::Occupancy{T}, n::Number) where {T} = Occupancy{T}(zero(T))
