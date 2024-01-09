"""
    CompetitiveLotkaVolterra{S} <: Model{Community,Biomass,S,Continuous}

Competitive Lotka-Voterra.
"""
struct CompetitiveLotkaVolterra{S} <: Model{Community,Biomass,S,Continuous}
    λ::Parameter
    α::Parameter
    K::Parameter
end 

initial(::CompetitiveLotkaVolterra) = rand(Uniform(0.5,1),4)
numspecies(clv::CompetitiveLotkaVolterra) = length(clv.K)


function ∂u(clv::CompetitiveLotkaVolterra, u, θ)
    λ, α, K = θ

    du = similar(u)
    for s in axes(u,1)
        @fastmath du[s] = u[s] * λ[s] * (1 - (sum([u[t]*α[s,t] for t in axes(u,1)]) / K[s]))
    end
    du
end

# ====================================================
#
#   Constructors
#
# =====================================================

function CompetitiveLotkaVolterra(;
    λ = [1, 0.72, 1.53, 1.27],
    α = [1.00 1.09 1.52 0. 
         0.   1.00 0.44 1.36
         2.33 0.   1.00 0.47
         1.21 0.51 0.35 1.00],
    K = [1. for i in 1:4])

    CompetitiveLotkaVolterra{Local}(
        Parameter(λ), 
        Parameter(α), 
        Parameter(K))
end

function replplot(::CompetitiveLotkaVolterra{Local}, traj::Trajectory) 
    u = timeseries(traj)
    ymax = max([extrema(x)[2] for x in timeseries(traj)]...)
    ts(s) = [mean(u[t][s,:]) for t in 1:length(traj)]
    p = lineplot( ts(1), 
        xlabel="time (t)", 
        ylabel="Biomass", 
        width=80,
        ylim=(0,ymax))

    for i in 2:length(u[1])
        lineplot!(p, ts(i))
    end 
    p
end

