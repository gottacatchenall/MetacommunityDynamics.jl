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


function competition(u, t, p)
    r, α = p 

    du = zeros(length(u))

    for s in eachindex(u)
        du[s] = u[s] * r[s] / (1 + sum([α[s,t] for t in eachindex(u)]))
    end
end

num_species = 5
tmax = 10.

λ = rand(Uniform(1,1.5), num_species)
α = ones(num_species, num_species)


θ = λ, α

u0 = rand(Uniform(2,2.5), num_species)

prob = ODEProblem(competition, u0, θ, (0,tmax))
