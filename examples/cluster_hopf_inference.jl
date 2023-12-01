using Turing, DiffEqBayes
using Distributions
using DifferentialEquations
using LinearAlgebra
using Suppressor
using DataFrames
using CairoMakie
using Random
using Roots
using CSV

include("../src/MetacommunityDynamics.jl")
using Main.MetacommunityDynamics

# We want to write a program that simulates the RM model across a spectrum of K
# values, with many replicates per k value. For each k value, we want to sample
# a set of observations from the true dynamics (with observation noise) and do
# inference of the parameter values. From these infered parameter values, we
# want to infer whether the system is on the subcritical or supercritical side
# of the Hopf bifurcation. We do this by computing the maximum real component of
# each eigenvalue $\text{Re}(\lambda)_{max}$ of the Jacobian around the
# fixed-point associated with the subcritical state. If
# $\text{Re}(\lambda)_{max} < 0$, we consider this inference of the subcritical
# state, and inference of the supercritical state otherwise. We measure the
# proportion of times out of the $N_r$ replicates that we infer the correct
# state. We predict that it will dip near K* (the Hopf point). We compare
# this across many frequencies of sampling, and predict on the whole worse
# performance as frequency decreases.

# We want to do this by running each of the $N_r$ replicates as a separate job
# on a cluster. 

# A single run should span each of the K values, and do a single replicate for
# each. 

"""
    eigenvalues(λ, α, η, β, γ, K)

Returns the eigenvalues of the RM system for a given set of parameters.
"""
function eigenvalues(λ, α, η, β, γ, K)
    x = 0.5λ * ( (γ*η/β) + (γ/(β*α*K)) - (2γ)/(α*K*(β-γ*η)) )
    δ = λ^2 * ( (γ*η/β) + γ/(β*α*K) - (2γ)/(α*K*(β - γ*η)) )^2 - ((4*λ*γ)/β)*(β - γ*η - γ/(α*K))

    x + 0.5sqrt(Complex(δ)), x - 0.5sqrt(Complex(δ))
end 

get_greatest_real_eig(K) = maximum(real.(eigenvalues()))
is_subcritical(K) = get_greatest_real_eig(K) < 0

get_rm(; λ=0.5, α=5.0, η=3.0, β=0.5, γ=0.1, K=0.25) = RosenzweigMacArthur(λ=λ, α=α, η=η, β=β, γ=γ, K=K)

# How much faster is it when we give it priors on everything but K that are
# highly informative? This might be worth it just for the sim

@model function fit_rm(data, prob; freq=4)   
    σ ~ InverseGamma(2,3) 
    λ ~ TruncatedNormal(0.5,0.5,0,1)
    α ~ Normal(3,0.5) 
    η ~ Normal(5.,0.5) 
    β ~ TruncatedNormal(0.5,0.5,0,1)  
    γ ~ TruncatedNormal(0.1,0.5,0,0.2) # Shifted way right, true is 0.1
    K ~ Uniform(0.23, 0.3) # This is way right too---maybe uniform on the interval we are siming across? 

    θ = parameters(RosenzweigMacArthur(λ=λ, α=α, η=η, β=β, γ=γ, K=K))
    predicted = solve(prob, Vern7(); p=θ, saveat=freq)
    try 
        predicted = predicted[1:size(obs,2)]
    catch 
        return
    end
    for i in size(data,2)
        data[:,i] ~ MvNormal(predicted[i], σ^2 * I)
    end
end


function main(
    rep; 
    K_range = 0.23:0.005:0.3,
    tspan = (1,300),
)
    mkpath("data")
    k_crit = 4/15

    df = DataFrame(
        rep = [],
        K=[], 
        sampling_frequency = [],
        actually_subcritical=[], 
        infered_subcritical=[],    
    )

    sample_freqs = 1:5

    for freq in sample_freqs
        for k in K_range
            rm = RosenzweigMacArthur(K=k)
            prob = problem(rm, tspan=tspan)
            traj = simulate(prob)
            obs = observe(Observer(), traj)

            inf_model = fit_rm(obs, prob.prob; freq=freq)

            chain = sample(inf_model, HMC(0.1, 5), MCMCSerial(), 300, 1)
            posterior_samples = sample(chain[[:λ, :α, :η, :β, :γ, :K]], 300) 
            θ = Dict(zip((posterior_samples |> mean).nt...))

            re_λ₁ = maximum(real.(eigenvalues(θ[:λ], θ[:α], θ[:η], θ[:β], θ[:γ], θ[:K])))
            
            push!(df.rep, rep)
            push!(df.K, k)
            push!(df.actually_subcritical, k < k_crit)
            push!(df.infered_subcritical, re_λ₁ < 0)
            push!(df.sampling_frequency, freq)
        end
    end 

    CSV.write(joinpath("data", "rep$rep.csv"), df)
end

id = parse(Int, ENV["SLURM_ARRAY_TASK_ID"])
main(id)