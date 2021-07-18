using MetacommunityDynamics
using DynamicGrids
using Plots
using Distributions
using Dispersal: Moore, DispersalKernel
using EcologicalNetworks: nichemodel, trophic_level, UnipartiteNetwork

number_of_species = 30
connectance = 0.3

dims = (25,25)

foodweb = nichemodel(number_of_species, connectance)
speciespool = DiscreteUnipartiteSpeciesPool(Symbol.(foodweb.S), Matrix(foodweb.edges)) # move these type changes to a method

trophicdict = trophic_level(foodweb)  # returns a dictionary 

resourcenames = filter(s -> trophicdict[String(s)] == 1.0, species(speciespool))
consumernames = filter(s -> trophicdict[String(s)] != 1.0, species(speciespool))

# I should store mass as auxilary data here probably because it can't change over time,
# but trait layers will be important for the next example

masses = Dict()
for (k,v) in zip(keys(trophicdict), values(trophicdict))
    masses[Symbol(k)] = 2^v
end 
masses = NamedTuple(masses)

# shortcut to make many independent rules instead of one big rule
fwe = FoodWebEating(LotkaVolterra(1.5), speciespool.metaweb, consumernames, resourcenames)  

    
consumermodel = 
    FoodWebEating(consumernames, resourcenames, LotkaVolterra(1.5), speciespool.metaweb) +
    AdjacentBernoulliDispersal(consumernames, DispersalKernel(radius=1), 0.1) +
    LinearMortality(consumernames, 0.2);

plantmodel = 
    LogisticGrowth(resourcenames) +
    AdjacentBernoulliDispersal(resourcenames, DispersalKernel(radius=3), 0.1) + 
    LinearMortality(resourcenames, 0.1);


fullmodel = consumermodel + plantmodel


# this should be a dictionary/namedtuple of :a => Matrix for a 

init = NamedTuple(merge(
    rand(Biomass, resourcenames, Exponential(10), dims...),
    rand(Biomass, consumernames, Exponential(10), dims...)));

arrayout = ArrayOutput(init, tspan=1:10, aux=(masses=masses, speciespool=speciespool,))
@time sim!(arrayout, fullmodel) 


arrayout[2]


m = (s0=5, s1=10)