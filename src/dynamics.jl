using DifferentialEquations
using Distributions

function dynamics(X)
    
    # X is a matrix with species on rows and patches on columns

    # Competition: 
    # ---------------------------------------
    # For species `s` in patch `i`
    # dXₛᵢ = Xₛᵢ * (rₛᵢ)/(1 + ∑ⱼ αⱼᵢ) + Iᵢₛ - Eᵢₛ

    # Trophism
    #
    # dXₛᵢ = Xₛᵢ * (rₛᵢ)/(1 + ∑ⱼ αⱼᵢ) 


end


function competition(u, p, t)
    r, α, K = p 

    du = zeros(length(u))

    for s in eachindex(u)
        du[s] = u[s] * r[s] * (1 - (sum([u[t]*α[s,t] for t in eachindex(u)]) / K[s]))
    end


    
    du
end




function diffusion_matrix(m, ϕ)
    idx = CartesianIndices(ϕ.matrix)
    [i[1] == i[2] ? 1-m : ϕ[i[1],i[2]] * m for i in idx]
end



num_species = 4
num_sites = 10
tmax = 100.


sg = SpatialGraph(10)
kern = DispersalKernel(decay=5, threshold=0.1)
ϕ = DispersalPotential(kern, sg)


D = diffusion_matrix(0.05, ϕ)



# Vano et al. chaotic params
r = [1, 0.72, 1.53, 1.27]
α = [1 1.09 1.52 0; 
     0 1 0.44 1.36;
     2.33 0 1 0.47
     1.21 0.51 0.35 1]
K = [1 for _ in 1:num_species]

θ = r, α, K

u0 = rand(Uniform(0.5,1), num_species, num_sites)



prob = ODEProblem(competition, u0, (0,tmax), θ, saveat=0:100);
sol = solve(prob);

ts(sol, s) = [sol.u[t][s] for t in 1:length(sol.t)]


p = lineplot(ts(sol, 1), 
    xlabel="time (t)", 
    ylabel="Abundance", 
    xlim=(0,100), 
    ylim=(0,1),
    width=80)
for s in 2:4
    lineplot!(p, ts(sol, s))
end

p