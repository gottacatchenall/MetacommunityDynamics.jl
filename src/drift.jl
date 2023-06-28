
@kwdef struct GaussianDrift{T} <: Stochasticity
    σ::T = 0.1
end

function ∂w(gd::GaussianDrift, x::T) where T<:Real
    gd.σ
end
function ∂w(gd::GaussianDrift, x::Vector{T}) where T<:Real
    [gd.σ for _ in 1:length(x)]
end
function ∂w(gd::GaussianDrift, x::Matrix{T}) where T<:Real
    σ = similar(x)
    σ .= gd.σ
end

function ∂w(gd::GaussianDrift, du, x::Matrix{T}) where T<:Real
    σ = similar(x)
    σ .= gd.σ
end
