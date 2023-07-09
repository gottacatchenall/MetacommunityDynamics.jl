# Inferring community dynamics

This use case shows how to build and run a model of community dynamics (the
Rosenzweig-MacArthur model, specifically).

```@example 1
using Turing, DiffEqBayes
using DifferentialEquations
using MetacommunityDynamics
using LinearAlgebra
using CairoMakie
```

The _Rosenzweig-MacArthur_ model is a model of consumer-resource dynamics. 

It is described by the equations 

$$\frac{dR}{dt} = \lambda R \bigg(1 - \frac{R}{K}\bigg) - \frac{\alpha CR}{1
+\alpha \eta R}$$

$$\frac{dC}{dt} = \beta \frac{\alpha CR}{1 + \alpha \eta R} - \gamma   C$$

where $R$ is the relative biomass of the resource, $C$ is the relative biomass
of the consumer, $\alpha$ is the attack-rate, $\eta$ is the handling type,
$\lambda$ is the maximum instric growth rate,  $\beta$ is the intrinsic
infintesimal growth of biomass for the consumer per unit resource, and $\gamma$
is the intrinsic death date of consumers. Note that this is equivalent to a
Lotka-Volterra model with a Holling Type-II functional response. 

Let's simulate it ,using only 3 lines of Julia. 

First we build the model

```@example 1
rm = RosenzweigMacArthur()
```

Then we setup the problem

```@example 1
prob = problem(rm)
```

Third we simulate!

```@example 1
traj = simulate(prob)
```

```@example 1
obs = observe(Observer(frequency=1), traj)
```

## Inference

First we define our model for inference.

```@example 2
using Turing, DiffEqBayes
using DifferentialEquations
using MetacommunityDynamics
using LinearAlgebra
using CairoMakie
rm = RosenzweigMacArthur(K=0.25)

freq = 4
prob = problem(rm, tspan=(1,100))
traj = simulate(prob)
obs = observe(Observer(frequency=freq, measurement_error=Normal(0,0.01)), traj)

@model function fit_rm(data, prob)
    σ ~ InverseGamma(2,3)
    λ ~ TruncatedNormal(0.5,1, 0,1.5)
    α ~ Normal(2,3.)
    η ~ Normal(2,3.)
    β ~ TruncatedNormal(0.5,1,0,1.5)
    γ ~ TruncatedNormal(0.5,1,0,1.5)
    K ~ TruncatedNormal(0.5,1.,0,1.5)

    θ = parameters(RosenzweigMacArthur(λ=λ, α=α, η=η, β=β, γ=γ, K=K))
    predicted = solve(prob, Tsit5(); p=θ, saveat=freq)[1:end-1]
    

    for i in eachindex(predicted)
        data[:,i] ~ MvNormal(predicted[i], σ^2 * I)
    end
end

model = fit_rm(obs, prob.prob)
chain = sample(model, NUTS(0.65), MCMCSerial(), 300, 1)


posterior_samples = sample(chain[[:λ, :α, :η, :β, :γ, :K]], 300)



endtime = 250
prob = problem(rm, tspan=(1,endtime))
true_traj = Array(simulate(prob).sol)


f = Figure(resolution=(2400,1500), fontsize=60)
ax = Axis(f[1,1], xlabel="Time", ylabel="Biomass")
ylims!(0,0.23)
xlims!(0,endtime)

ensemble_traj = zeros(2,endtime)

for p in eachrow(Array(posterior_samples))
    λ, α, η, β, γ, K =  p
    θ = parameters(RosenzweigMacArthur(λ=λ, α=α, η=η, β=β, γ=γ, K=K))
    sol_p = solve(prob.prob, Tsit5(); tspan=(1,endtime),p=θ, saveat=1)

    ensemble_traj .+= Array(sol_p)

    lines!(ax, sol_p.t, [sol_p.u[i][1] for i in eachindex(sol_p.t)], color=(:lightskyblue1, 0.3))
    lines!(ax, sol_p.t, [sol_p.u[i][2] for i in eachindex(sol_p.t)], color=(:lightcoral, 0.15))
end

ensemble_traj = ensemble_traj ./ length(posterior_samples)

scatter!(ax, 1:freq:100, obs[1,:], color=(:dodgerblue))
scatter!(ax, 1:freq:100, obs[2,:], color=(:red, 0.5))



ens_C = lines!(ax, 1:size(true_traj,2), ensemble_traj[1,:], color=:dodgerblue, linewidth=8, linestyle=:dash)
ens_R = lines!(ax, 1:size(true_traj,2), ensemble_traj[2,:], color=:red, linewidth=8, linestyle=:dash)


true_C = lines!(ax, 1:size(true_traj,2), true_traj[1,:], color=:dodgerblue, linewidth=8)
true_R = lines!(ax, 1:size(true_traj,2), true_traj[2,:], color=:red, linewidth=8)
obs_C = scatter!(ax, 1:freq:100, obs[1,:], strokewidth=6, markersize=42,strokecolor=(:dodgerblue), color=:white)
obs_R = scatter!(ax, 1:freq:100, obs[2,:], strokewidth=6, markersize=42, strokecolor=(:red, 0.5), color=:white)

axislegend(ax,
[true_C, true_R],
["Consumer", "Resource"],position=:rt)

f
```

