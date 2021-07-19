using MetacommunityDynamics
using DynamicGrids
using Plots
using Distributions
using Dispersal: Moore, DispersalKernel
using EcologicalNetworks: nichemodel, trophic_level, UnipartiteNetwork

number_of_species = 30
connectance = 0.15

dims = (25,25)

foodweb = nichemodel(number_of_species, connectance)
speciespool = DiscreteUnipartiteSpeciesPool(Symbol.(foodweb.S), Matrix(foodweb.edges)) # move these type changes to a method

trophicdict = trophic_level(foodweb)  # returns a dictionary 

resourcenames = filter(s -> trophicdict[String(s)] == 1.0, species(speciespool))
consumernames = filter(s -> trophicdict[String(s)] != 1.0, species(speciespool))

masses = Dict()
for (k,v) in zip(keys(trophicdict), values(trophicdict))
    masses[Symbol(k)] = 2^v
end 
masses = NamedTuple(masses)
    
consumermodel = 
    FoodWebEating(consumernames, resourcenames, LotkaVolterra(0.03), speciespool.metaweb) +
  #  AdjacentBernoulliDispersal(consumernames, DispersalKernel(radius=1), 0.1) +
    LinearMortality(consumernames, 0.01);

plantmodel = 
    LogisticGrowth(resourcenames) +
  #  AdjacentBernoulliDispersal(resourcenames, DispersalKernel(radius=3), 0.1) + 
    LinearMortality(resourcenames, 0.01);


fullmodel = consumermodel + plantmodel

init = NamedTuple(merge(
    rand(Biomass, resourcenames, Exponential(10), dims...),
    rand(Biomass, consumernames, Exponential(10), dims...)));

arrayout = ArrayOutput(init, tspan=1:1000, aux=(masses=masses, speciespool=speciespool,))
@time sim!(arrayout, fullmodel) 




"""
    plots : 
"""

mat = zeros(number_of_species, 1000)

spnames = []
for t = 1:1000
  ind = 1

  for (k,v) in zip(keys(arrayout[t]), values(arrayout[t]))
    mat[ind, t] = sum(v)
    push!(spnames, k)
    ind += 1
  end  
end


plot(mat', legend=:outerright, frame=:box, dpi=150)

xaxis!("timestep")
yaxis!("biomass") 

savefig("foodwebtraj.png")