
@kwdef struct CompetitiveLotkaVolterra <: Model 
    λ = [1, 0.72, 1.53, 1.27]
    α = [1.00 1.09 1.52 0. 
         0.   1.00 0.44 1.36
         2.33 0.   1.00 0.47
         1.21 0.51 0.35 1.00]
    K = [1. for i in 1:4]
end 


function ∂u(clv::CompetitiveLotkaVolterra)
    λ, α, K = clv.λ, clv.α, clv.K
    function foo(x)
        du = similar(x)
        for s in axes(x,1)
            @fastmath du[s] = x[s] * λ[s] * (1 - (sum([x[t]*α[s,t] for t in 1:size(x,1)]) / K[s]))
        end
        du
    end
    foo 
end

# This has to return a function that returns
# a function mapping u -> du as a function of the diffusion matrix 
# provided

# should diffusion always act after local, so can assume du as input?
function ∂x(diffusion_mat)
    ϕ = diffusion_mat
    function foo(du)
        du = ϕ .* du
    end

    # add a "zero catcher" function to return 0 if u <= 0
    foo 
end



clv =  CompetitiveLotkaVolterra()

foo = ∂u(clv)



# the parameters are baked into u, which helps 


bar(u,p,t) = foo(u)

u0 = rand(Uniform(0.5,1), 4, 1)

prob = ODEProblem(bar, u0, (0,100.), (), saveat=0:100);

@time sol = solve(prob);


ts(sol, s) = [sum(sol.u[t][s,:]) for t in 1:length(sol.t)]
p = lineplot(ts(sol, 1), 
    xlabel="time (t)", 
    ylabel="Abundance", 
    width=80)
for i in 2:4
lineplot!(p, ts(sol, i))
end
p   