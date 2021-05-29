struct Occupancy{V}
    val::V
end

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

DynamicGrids.to_rgb(::ObjectScheme, obj::Occupancy) = to_rgb(obj.val)
DynamicGrids.to_rgb(scheme, obj::Occupancy) = to_rgb(obj.val)