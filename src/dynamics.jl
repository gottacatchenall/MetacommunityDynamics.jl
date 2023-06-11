using DifferentialEquations
using Distributions

function dynamics(X)
    
    # X is a matrix with species on rows and patches on columns

    # Competition: 
    # ---------------------------------------
    # For species `s` in patch `i`
    # dXₛᵢ = Xₛᵢ * (rₛᵢ)/(1 + ∑ⱼ αⱼᵢ) + Iᵢₛ - Eᵢₛ

    # Trophism
    # dXₛᵢ = Xₛᵢ * (rₛᵢ)/(1 + ∑ⱼ αⱼᵢ) 

    # 

end


function competition(u, p, t)
    r, α, K = p 

    du = zeros(size(u,1), size(u,2))

    for s in axes(u,1)
        for p in axes(u,2)
            du[s,p] = u[s,p] * r[s] * (1 - (sum([u[t,p]*α[s,t] for t in 1:size(u,1)]) / K[s]))
        end
    end
    
    du .+= (D * u0')'
    #du
end


function diffusion_matrix(m, ϕ)
    idx = CartesianIndices(ϕ.matrix)
    [i[1] == i[2] ? 1-m : ϕ[i[1],i[2]] * m for i in idx]
end



num_species = 4
num_sites = 10
tmax = 100.


sg = SpatialGraph(10)
kern = DispersalKernel(decay=5, threshold=0.05)
# i should overload plot

ϕ = DispersalPotential(kern, sg)


D = diffusion_matrix(0.05, ϕ)



# Vano et al. chaotic params
r = [1, 0.72, 1.53, 1.27]
α = [1 1.09 1.52 0 
     0 1 0.44 1.36
     2.33 0 1 0.47
     1.21 0.51 0.35 1]
K = [1 for _ in 1:num_species]

θ = r, α, K

u0 = rand(Uniform(0.5,1), num_species, num_sites)

prob = ODEProblem(competition, u0, (0,tmax), θ, saveat=0:100);


sol = solve(prob);

#ts(sol, s) = [sum(sol.u[t][s,:]) for t in 1:length(sol.t)]


p = lineplot(ts(sol, 1), 
    xlabel="time (t)", 
    ylabel="Abundance", 
    width=80,
    ylim=(0,10))
for s in 2:4
    lineplot!(p, ts(sol, s))
end

p