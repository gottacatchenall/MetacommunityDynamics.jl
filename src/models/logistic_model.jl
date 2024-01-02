"""
    LogisticModel{S} <: Model{Population,Biomass,S,Continuous}

Logistic Model. 
"""
struct LogisticModel{S} <: Model{Population,Biomass,S,Continuous}
    λ::Parameter
    K::Parameter
    α::Parameter
end 

discreteness(::LogisticModel{T}) where T = MetacommunityDynamics.Continuous 
initial(::LogisticModel{T}) where T = 5.
numspecies(::LogisticModel) = 1


function ∂u(lm::LogisticModel, u, θ)
    λs, Ks, αs = θ
    N = u[1]
    N <= 0 && return 0
    λ, K, α = λs[1], Ks[1], αs[1] 
    return @fastmath λ*u*(1-(N/K)^α)
end


# ====================================================
#
#   Constructors
#
# =====================================================

function LogisticModel(;
    λ::Vector{T} = [1.2],
    K::Vector{T} = [50.],
    α::Vector{T}  = [1.],
) where T 
    LogisticModel{Local}(
        Parameter(λ), 
        Parameter(K), 
        Parameter(α))
end

# ====================================================
#
#   Plotting 
#
# =====================================================

function replplot(::LogisticModel{Spatial}, traj::Trajectory)
    u = vcat(Array(traj.sol.u)...)
    ymax = max(u...)
    p = lineplot(u[:,1], 
        xlabel="time (t)", 
        ylabel="Biomass", 
        width=80,
        ylim=(0,ymax))

    for i in eachcol(u)[2:end]
        lineplot!(p, i)
    end
    p
end
