using DifferentialEquations
using Distributions
using MetacommunityDynamics
using CairoMakie
using NeutralLandscapes
using ProgressMeter


rosen = RosenzweigMacArthur()
p = problem(rosen)
@time sol = simulate(p)


gd = GaussianDrift(0.01) 
p = problem(RosenzweigMacArthur(), gd);
@time sol = simulate(p)


lm = LogisticModel(λ=[0.1])
p = problem(lm)
sol = simulate(p)

p = problem(lm, GaussianDrift(3.))
@time sol = simulate(p)

p = problem(BevertonHolt())
@time sol = simulate(p)

sol


p = problem(CompetitiveLotkaVolterra())
@time sol = simulate(p)



p = problem(CompetitiveLotkaVolterra(), GaussianDrift(0.005))
@time sol = simulate(p)

#----------------------------------------------------------
# spatial 


rosen = RosenzweigMacArthur()

sp = SpeciesPool(2)
sg = SpatialGraph()

function niche(model, traits, local_env)
    θ = paramdict(model)

    λ_adjusted = similar(θ[:λ])
    for (i,λᵢ) in enumerate(θ[:λ])
        adjusted_λᵢ = λᵢ > 0 ? λᵢ*exp(-(traits[:x][i] - local_env[:e1])^2) : 0
        λ_adjusted[i] = adjusted_λᵢ
    end

    θ[:λ] = λ_adjusted
    θ
end


spatmodel = spatialize(rosen, sg, sp; niche=niche)

dk = DispersalKernel(max_distance=0.5)



diff =Diffusion(0.01, DispersalPotential(dk,sg))

prob = problem(spatmodel, diff)

@time simulate(prob)





# possible case studies:
#   - metapopulatoin synchrony across max distance threshold
#   - number of persisting RM communities in a spatial graph across different demo stochasticities



prob = problem(spatmodel, diff, GaussianDrift(0.005))
@time traj = simulate(prob)




lm = LogisticModel()
sg = SpatialGraph(EnvironmentLayer())
t = Dict(
    :μ => [0.5],
    :σ => [0.5],
)
sp = SpeciesPool(traits=t)

niche = GaussianNiche()

ϕ = DispersalPotential(DispersalKernel(max_distance=0.4), sg)
D = Diffusion(0.01, ϕ)

spatiallm = spatialize(lm, sg,  sp, niche, D)
prob = problem(spatiallm, Deterministic)
traj = simulate(prob)


prob = problem(spatiallm, GaussianDrift(3.))
@time traj = simulate(prob)




clv = CompetitiveLotkaVolterra()
el = EnvironmentLayer(generator=PlanarGradient())


σ = 0.1
niche = GaussianNiche()

ϕ = DispersalPotential(DispersalKernel(max_distance=0.4), sg)
D = Diffusion(0.01, ϕ)


prob = problem(spatialclv, Deterministic)
@time traj = simulate(prob)

# measure alpha div vs. σ

_tfactory(σ) = Dict(
    :μ => [0.2, 0.4, 0.6, 0.8],
    :σ => fill(σ,4),
)


σs = 0.01:0.01:0.5


nreps = 64

trajset = []

@showprogress for σ in σs
    trajs = []
    sp = SpeciesPool(traits=_tfactory(σ))
    for i in 1:nreps
        sg = SpatialGraph(el)
        spatialclv = spatialize(clv, sg,  sp, niche, D)    
        prob = problem(spatialclv)
        traj = simulate(prob)
        push!(trajs, traj)
    end 
    push!(trajset, trajs)
end 











a = Array(trajs[end].sol)

f = Figure()
ax = Axis(f[1,1])
cs = [:dodgerblue, :mediumpurple4, :forestgreen, :gray50]

a

nt = size(a,3)
entropy(x) = -sum([xi * log(xi) for xi in x])

ent = []

last_steps = 50

for trajs in trajset
    thisset = []
    for t in trajs
        a = Array(t.sol)
        a[findall(x->x<0,a)] .= 0

        thistraj = []
        for site in 1:size(a,2)
            push!(thistraj, mean(entropy.([a[:,site,t] for t in nt-last_steps:nt])))
        end
        push!(thisset, mean(thistraj))
    end
    push!(ent, thisset)
end 

f = Figure()
ax = Axis(f[1,1])

for (i, σ) in enumerate(σs)
    scatter!(ax, [σ], Float32[mean(ent[i])])
end

ent
f


f


foo
foo
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