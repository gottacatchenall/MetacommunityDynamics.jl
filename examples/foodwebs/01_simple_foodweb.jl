using MetacommunityDynamics
using DynamicGrids
using Plots
using Distributions
using EcologicalNetworks: nichemodel, trophic_level

number_of_species = 30
connectance = 0.3

dims = (250, 250)

foodweb = nichemodel(number_of_species, connectance)
speciespool = DiscreteUnipartiteSpeciesPool(Symbol.(foodweb.S), Matrix(foodweb.edges)) # move these type changes to a method
trophicdict = trophic_level(foodweb)  # returns a dictionary 

plantpool = filter(s -> trophicdict[s] == 1.0, speciespool)
notplantpool = filter(s -> trophicdict[s] != 1.0, speciespool)

plants = layernames(plantpool)
notplants = layernames(notplantpool)

# one approach would be to make mass layer for every species which is the same everywhere are doesn't change
# waste of memory perhaps, should make a way to flag that a species trait does not vary over space 
masslayers = [fill(2^l, dims...) for (s, l) in trophicdict]
masslayers = generate(StaticTrait, trophicdict, l -> 2^l) # allometric scaling via yodzis innes

# this should be a dictionary/namedtuple of :a => layer for a 
init = layers(plants) + layers(notplants) + masslayers

consumermodel = 
    Eating{notplants, plants}(LotkaVolterra()) +  # must assert masslayers has same names as notplants
    DiffusionDispersal{notplants}() +
    LinearMortality{notplants}(0.2)

plantmodel = 
    LogisticGrowth{plants}() +
    WindDispersal{plants}() + 
    LinearMortality{plants}(0.1)   

    






