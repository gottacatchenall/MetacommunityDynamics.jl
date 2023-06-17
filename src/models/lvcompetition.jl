
@kwdef struct CompetitiveLotkaVolterra <: Model
    λ = [1, 0.72, 1.53, 1.27]
    α = [1.00 1.09 1.52 0. 
         0.   1.00 0.44 1.36
         2.33 0.   1.00 0.47
         1.21 0.51 0.35 1.00]
    K = [1. for i in 1:4]
end 
initial(::CompetitiveLotkaVolterra) = rand(Uniform(0.5,1), 4, 1)
discreteness(::CompetitiveLotkaVolterra) = Continuous 

factory(clv::CompetitiveLotkaVolterra) = begin
    (u,θ,_) -> ∂u(clv, u, θ)
end

function ∂u(clv::CompetitiveLotkaVolterra, u, θ)
    λ, α, K = θ
    du = similar(u)
    for s in axes(u,1)
        @fastmath du[s] = u[s] * λ[s] * (1 - (sum([u[t]*α[s,t] for t in 1:size(u,1)]) / K[s]))
    end
    du
end


function factory(clv::CompetitiveLotkaVolterra, s::T) where {T<:Stochasticity}
    (u,θ,_) -> ∂u(clv, u, θ), (u,_,_) -> ∂w(s, u)
end


function parameters(clv::CompetitiveLotkaVolterra)
    fns = fieldnames(CompetitiveLotkaVolterra)
    [getfield(clv, f) for f in fns]
end

function replplot(::CompetitiveLotkaVolterra, traj)
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



# This has to be a function that returns
# a function mapping u -> du as a function of the diffusion matrix 
# provided
# should diffusion always act after local, so can assume du as input?

# PDEs make things hard because you have to consider infinitesemals across
# space. In spatial graphs, you don't have to do that.

function ∂x(diffusion_mat)
    ϕ = diffusion_mat
    function foo(du)
        du = ϕ .* du
    end

    # add a "zero catcher" function to return 0 if u <= 0
    foo 
end

#=

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
p   =#