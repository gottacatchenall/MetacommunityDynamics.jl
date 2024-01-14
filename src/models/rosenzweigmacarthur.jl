"""
    struct RosenzweigMacArthur{S<:Spatialness} <: Model{Community,Biomass,S,Continuous}


Dynamics given by

``\\frac{dR}{dt} = \\lambda R \\bigg(1 - \\frac{R}{K}\\bigg) - \\frac{\\alpha CR}{1 +\\alpha \\eta R}``

``\\frac{dC}{dt} = \\beta \\frac{\\alpha CR}{1 + \\alpha \\eta R} - \\gamma   C``

"""
struct RosenzweigMacArthur{S<:Spatialness} <: Model{Community,Biomass,S,Continuous}
    metaweb::Parameter        # metaweb, not a parameter of inference
    λ::Parameter       # λ[i] max instaneous growth rate of i
    α::Parameter              # α[i,j] = attack rate of i on j
    η::Parameter              # η[i, j] =  handling rate of i on j
    β::Parameter              # β[i, j] = growth in i eating j
    γ::Parameter       # heterotroph death rate (0 for all autotrophs)
    K::Parameter       # autotroph carrying capacity (0 for heterotrophs)
end 



# No longer necessary with this as parameter to model type
# discreteness(::RosenzweigMacArthur) = Continuous 

initial(::RosenzweigMacArthur) = [0.2, 0.2]  # note this is only valid for the default params

numspecies(rm::RosenzweigMacArthur) = length(rm.K)


function du_dt(C,R,λ,α,η,β,γ,K)
    @fastmath dR = λ*R*(1-(R/K)) - (α*R*C)/(1+α*η*R)
    @fastmath dC = (β*C*R*α)/(1+α*η*R) - γ*C
    dC,dR
end

function ∂u(rm::RosenzweigMacArthur, u, θ)
    M, λ, α, η, β, γ, K = θ

    I = findall(!iszero, M)
    du = similar(u)
    du .= 0
    for i in I
        ci,ri = i[1], i[2]
        C,R = u[ci], u[ri]
        λᵢ, αᵢ, ηᵢ, βᵢ, γᵢ, Kᵢ = λ[ri], α[ci,ri], η[ci,ri], β[ci,ri], γ[ci], K[ri]
        dC, dR = du_dt(C,R, λᵢ, αᵢ, ηᵢ, βᵢ, γᵢ, Kᵢ)
        du[ci] += dC
        du[ri] += dR
    end 
    du      
end


# ====================================================
#
#   Constructors
#
# =====================================================

function RosenzweigMacArthur(;
    metaweb::Matrix = [0 1; 0 0],
    λ::Vector =  [0.0, 0.5],   
    α::Matrix =  [0.0  5.0;    
          5.0  0.0],
    η::Matrix =  [0.0  3.0;   
          3.0  0.0],
    β::Matrix =  [0.0  0.5; 
          0.5  0.0],
    γ::Vector =  [0.1, 0.],  
    K::Vector =  [0.0, 0.3]
)
    RosenzweigMacArthur{Local}(
        Parameter(metaweb), 
        Parameter(λ), 
        Parameter(α), 
        Parameter(η), 
        Parameter(β), 
        Parameter(γ), 
        Parameter(K)
    )
end

function RosenzweigMacArthur(;
    λ::T = 0.5, 
    α::T = 5.0,
    η::T = 3.0,
    β::T = 0.5,
    γ::T = 0.1,
    K::T = 0.3) where T<:Number
    
    RosenzweigMacArthur{Local}(
        Parameter([0 1; 0 0]),
        Parameter([0., λ]),
        Parameter([0.0  α;  
            0.0  0.0]),
        Parameter([0.0  η;    
            0.0 0.0]),
        Parameter([0.0  β;   
            0.0  0.0]),
        Parameter([γ, 0.]),         
        Parameter([0.0, K])
    )   
end


# ====================================================
#
#   Tests
#  
#
# =====================================================


@testitem "Rosenzweig-MacArthur constructor works" begin
    @test typeof(RosenzweigMacArthur()) <: Model
    @test typeof(RosenzweigMacArthur()) <: RosenzweigMacArthur
end
