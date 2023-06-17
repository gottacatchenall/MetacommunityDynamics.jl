using DifferentialEquations
using Distributions
using MetacommunityDynamics



rm = RosenzweigMacArthur()
p = problem(rm, Deterministic)
@time sol = simulate(p)

lm = LogisticModel(λ=0.1)
p = problem(lm)
@time sol = simulate(p)


p = problem(BevertonHolt(R₀=1.2, K=50.), Deterministic)
@time sol = simulate(p)

sol


p = problem(CompetitiveLotkaVolterra(), Deterministic)
@time sol = simulate(p)


#=

function dynamics(X)
    
    # X is a matrix with species on rows and patches on columns

    # LV Competition: 
    # ---------------------------------------
    # For species `s` in patch `i`
    # 
    # dXₛᵢ = Xₛᵢ * (rₛᵢ) * (1 - (∑ⱼ αⱼᵢ)/Kₛᵢ ) + Iᵢₛ - Eᵢₛ

    # Trophism
    # dXₛᵢ = Xₛᵢ * rₛᵢ
    # 

end


function competition(u, p, t)
    r, α, K, _ = p 
    du = zeros(size(u,1), size(u,2))
    for s in axes(u,1)
        for p in axes(u,2)
            du[s,p] = u[s,p] * r[s] * (1 - (sum([u[t,p]*α[s,t] for t in 1:size(u,1)]) / K[s]))
        end
    end
    du .+= (D * u')'
    du
end


function diffusion_matrix(m, ϕ)
    idx = CartesianIndices(ϕ.matrix)
    [i[1] == i[2] ? 1-m : ϕ[i[1],i[2]] * m for i in idx]
end


function noise(u, p, t)
    _, _, _, σ = p
    σ .* u
end

num_species = 4
num_sites = 10
tmax = 100.


sg = SpatialGraph(25)

kern = DispersalKernel(decay=5, max_distance=0.5√2)


ϕ = DispersalPotential(kern, sg)
D = diffusion_matrix(0.001, ϕ)

# Vano et al. chaotic params
r = [1, 0.72, 1.53, 1.27]
α = [1 1.09 1.52 0 
     0 1 0.44 1.36
     2.33 0 1 0.47
     1.21 0.51 0.35 1]
K = [1 for _ in 1:num_species]

σ = 0.25

θ = r, α, K, σ

u0 = rand(Uniform(0.5,1), num_species, num_sites)

prob = ODEProblem(competition, u0, (0,tmax), θ, saveat=0:100);

prob = SDEProblem(competition, noise, u0, (0, tmax), θ, saveat=0:100)

sol = solve(prob);

ts(sol, s) = [sum(sol.u[t][s,:]) for t in 1:length(sol.t)]


p = lineplot(ts(sol, 1), 
    xlabel="time (t)", 
    ylabel="Abundance", 
    width=80,
    ylim=(0,20))
for s in 2:4
    lineplot!(p, ts(sol, s))
end

p
=#