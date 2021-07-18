using MetacommunityDynamics
using DynamicGrids
using Plots
using Distributions
using Dispersal: Moore, DispersalKernel
using EcologicalNetworks: nichemodel, trophic_level, UnipartiteNetwork

number_of_species = 30
connectance = 0.3

dims = (250, 250)

foodweb = nichemodel(number_of_species, connectance)
speciespool = DiscreteUnipartiteSpeciesPool(Symbol.(foodweb.S), Matrix(foodweb.edges)) # move these type changes to a method

trophicdict = trophic_level(foodweb)  # returns a dictionary 

resourcenames = filter(s -> trophicdict[String(s)] == 1.0, species(speciespool))
consumernames = filter(s -> trophicdict[String(s)] != 1.0, species(speciespool))

massnames = []
masses = Dict()
for (k,v) in zip(keys(trophicdict), values(trophicdict))
    layername = Symbol("mass_", k)
    push!(massnames, layername)
    masses[layername] = fill(Trait, 2^v, dims)  # allometric scaling via yodzis innes
end 


consumermodel = 
    Eating{Tuple{consumernames..., resourcenames..., massnames...}}() +  # must assert masslayers has same names as notplants
    AdjacentBernoulliDispersal{Tuple{consumernames...}}(DispersalKernel(radius=1), 0.1) +
    LinearMortality{Tuple{consumernames...}}(0.2)

plantmodel = 
    LogisticGrowth{Tuple{resourcenames...}}() +
    AdjacentBernoulliDispersal{Tuple{resourcenames...}}(DispersalKernel(radius=3), 0.1) + 
    LinearMortality{Tuple{resourcenames...}}(0.1)   


fullmodel = consumermodel + plantmodel
    
# this should be a dictionary/namedtuple of :a => Matrix for a 
init = merge(
    rand(Biomass, resourcenames, Exponential(10), dims...),
    rand(Biomass, consumernames, Exponential(10), dims...),
    masses);




    
