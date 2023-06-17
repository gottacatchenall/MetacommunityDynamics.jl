@kwdef struct LogisticModel{T<:Number} <: Model
    λ::T = 1.2
    K::T = 50.
    α::T = 1.
end 

discreteness(::LogisticModel{T}) where T = MetacommunityDynamics.Continuous 
initial(::LogisticModel{T}) where T = 5.

function ∂u(lm::LogisticModel, u, θ)
    λ, K, α = θ
    return @fastmath λ*u*(1-(u/K)^α)
end


function factory(lm::LogisticModel)
    (u,θ,_) -> ∂u(lm, u, θ)
end

function factory(lm::LogisticModel, s::T) where {T<:Stochasticity}
    (u,θ,_) -> ∂u(lm, u, θ), (u,_,_) -> ∂w(s, u)
end


function parameters(lm::LogisticModel)
    # everything is a paremeter
    fns = fieldnames(LogisticModel)
    [getfield(lm, f) for f in fns]
end


function replplot(lm::LogisticModel, traj)
    u = timeseries(traj)
    ymax = max(u...)
    p = lineplot(u, 
        xlabel="time (t)", 
        ylabel="Biomass", 
        width=80,
        ylim=(0,ymax))
    p
end
