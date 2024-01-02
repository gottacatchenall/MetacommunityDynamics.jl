struct TrophicLotkaVolterra{S<:Spatialness} <: Model{Community,Biomass,S,Continuous}
    r::Parameter
    A::Parameter
end


initial(::TrophicLotkaVolterra) = [0.1, 1.0]
numspecies(lv::TrophicLotkaVolterra) = length(lv.r)

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


