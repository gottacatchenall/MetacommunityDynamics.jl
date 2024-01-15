struct TrophicLotkaVolterra{S<:Spatialness} <: Model{Community,Biomass,S,Continuous}
    r::Parameter
    A::Parameter
end


initial(::TrophicLotkaVolterra) = [0.1, 1.0]
numspecies(lv::TrophicLotkaVolterra{Local}) = length(lv.r)
numspecies(lv::TrophicLotkaVolterra{Spatial}) = length(lv.r.value[1])

function ∂u(::TrophicLotkaVolterra, u, θ)
    r, A = θ
    @fastmath u .* (r .+ A*u)
end


# ====================================================
#
#   Constructors
#
# =====================================================

function TrophicLotkaVolterra(;
    r::Vector = [-0.1, 0.02],
    A::Matrix = [0 0.2;
                 -0.1 0]
)
    TrophicLotkaVolterra{Local}(
        Parameter(r),
        Parameter(A)
    )
end

function TrophicLotkaVolterra(;
    λ::T = 0.02,
    α::T = 0.2,
    β::T = 0.1,
    γ::T = 0.1
) where T<:Number
    r = [-γ, λ]
    A = [0. α; -β 0]
    TrophicLotkaVolterra{Local}(
        Parameter(r),
        Parameter(A)
    )
end

