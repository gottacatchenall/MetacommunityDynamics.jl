using MetacommunityDynamics
using DynamicGrids
using Plots
using Distributions
using EcologicalNetworks: nichemodel, trophic_level

number_of_species = 30
connectance = 0.3

dims = (250, 250)

foodweb = DiscreteUnipartiteSpeciesPool(nichemodel(number_of_species, connectance))
trophicdict = trophic_level(foodweb)  # returns a dictionary 

plantpool = filter(s -> trophicdict[s] == 1.0, foodweb)
notplantpool = filter(s -> trophicdict[s] != 1.0, foodweb)

plants = layernames(plantspecies)
notplants = layernames(notplants)

# one approach would be to make mass layer for every species which is the same everywhere are doesn't change
# waste of memory perhaps, should make a way to flag that a species trait does not vary over space 
masslayers = [fill(2^l, dims...) for l in trophiclevels(foodweb)]
masslayers = generate(StaticTrait, trophcdict, l -> 2^l) # allometric scaling via yodzis innes

everylayer = layers(plants) + layers(notplants) + masslayers

consumermodel = 
    Eating{notplants}(YodzisInnes(masses)) +
    DiffusionDispersal{notplants}() +
    LinearMortality{notplants}(0.2)

plantmodel = 
    LogisticGrowth{plants}() +
    WindDispersal{plants}() + 
    LinearMortality{plants}(0.1)   

    





