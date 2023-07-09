"""
    CompetitiveLotkaVolterra{S} <: Model{Community,Biomass,S,Continuous}

Competitive Lotka-Voterra.
"""
struct CompetitiveLotkaVolterra{S} <: Model{Community,Biomass,S,Continuous}
    λ::Parameter
    α::Parameter
    K::Parameter
end 

initial(::CompetitiveLotkaVolterra) = rand(Uniform(0.5,1), 4, 1)
numspecies(clv::CompetitiveLotkaVolterra) = size(clv.α, 1)


function ∂u(clv::CompetitiveLotkaVolterra, u, θ)
    λ, α, K = θ

    du = similar(u)
    for s in axes(u,1)
        @fastmath du[s] = u[s] * λ[s] * (1 - (sum([u[t]*α[s,t] for t in axes(u,1)]) / K[s]))
    end
    du
end

function ∂u_spatial(clv::CompetitiveLotkaVolterra, u, θ)
    λ, α, K = θ

    du = similar(u)
    du .= 0
    n_species = numspecies(clv)
    n_sites = size(u,2)
    for site in 1:n_sites
        for sp in 1:n_species
            if u[sp,site] > 0 
                @fastmath du[sp, site] = u[sp, site] * λ[sp,site] * (1 - (sum([u[t,site]*α[sp,t] for t in 1:n_species]) / K[sp]))
            else
                u[sp,site] = 0
            end
        end 
    end
    du 
end


# ====================================================
#
#   Constructors
#
# =====================================================

function CompetitiveLotkaVolterra(;
    λ = [1, 0.72, 1.53, 1.27],
    α = [1.00 1.09 1.52 0. 
         0.   1.00 0.44 1.36
         2.33 0.   1.00 0.47
         1.21 0.51 0.35 1.00],
    K = [1. for i in 1:4])

    CompetitiveLotkaVolterra{Local}(
        Parameter(λ), 
        Parameter(α), 
        Parameter(K))
end

function replplot(::CompetitiveLotkaVolterra{Local}, traj::Trajectory) 
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



function replplot(::CompetitiveLotkaVolterra{Spatial}, traj::Trajectory) 
    u = Array(traj.sol)    
    n_species, n_locations, n_timesteps = size(u)
    ymax = max(u...)
    
    p = lineplot(u[1,1,:], 
        xlabel="time (t)", 
        ylabel="Biomass", 
        width=80,
        ylim=(0,ymax))
         
    cols = n_species < 7 ? [:blue, :red, :green, :red, :purple, :red] : fill(:blue, n_species)
    for s in eachslice(u, dims=(2))
        for sp in 1:n_species
            lineplot!(p, s[sp,:], color=cols[sp])
        end
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