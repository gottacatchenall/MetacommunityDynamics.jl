using MetacommunityDynamics
using DynamicGrids
using Plots
using Distributions
using Dispersal: Moore, DispersalKernel
using ColorSchemes
using EcologicalNetworks: mpnmodel, trophic_level, UnipartiteNetwork, degree, richness


number_of_species = 200
connectance = 0.05
forbiddenlinkprob = 0.5

foodweb = mpnmodel(number_of_species, connectance, forbiddenlinkprob)

sp = DiscreteUnipartiteSpeciesPool(Symbol.(foodweb.S), Matrix(foodweb.edges)) # move these type changes to a method
trophicdict = trophic_level(foodweb)  # returns a dictionary 

resource = filter(s -> trophicdict[String(s)] == 1, sp.species)
consumers = filter(s -> trophicdict[String(s)] > 1, sp.species)
    
consumermodel = 
    FoodWebEating(consumers, resource, LotkaVolterra(0.2), metaweb(sp)) +
    AdjacentBernoulliDispersal(consumers, DispersalKernel(radius=1), 0.1) +
    RandomExtinction(consumers, probability=0.1) +
    LinearMortality(consumers, 0.01);

plantmodel = 
    LogisticGrowth(resource) +
    AdjacentBernoulliDispersal(resource, DispersalKernel(radius=2), 0.1) ;

fullmodel = consumermodel + plantmodel;


dim = (50,50)
ntimesteps = 300

init = NamedTuple(merge(
    rand(Biomass, resource, Exponential(10), dim...),
    rand(Biomass, consumers, Exponential(10), dim...)));

arrayout = ArrayOutput(init, tspan=1:ntimesteps)
@time sim!(arrayout, fullmodel); 


"""
    plots : 
"""

mat = zeros(number_of_species, ntimesteps)

spnames = []
for t = 1:ntimesteps
  ind = 1

  for (k,v) in zip(keys(arrayout[t]), values(arrayout[t]))
    mat[ind, t] = sum(v)
    push!(spnames, k)
    ind += 1
  end  
end



plt = plot(legend=:none)
xaxis!(plt, xticks=[i for i in 0:20:ntimesteps],"timestep")
yaxis!(plt, "log2(biomass)") 
for s in 1:number_of_species
    speciesname = spnames[s]
    thiscol = get(ColorSchemes.thermal, trophicdict[String(speciesname)]/max(values(trophicdict)...))

    @show thiscol, speciesname, trophicdict[String(speciesname)]
    plot!(plt, 1:ntimesteps, mat[s,:], la=0.7, lw=3, c=thiscol, colorbar_title="trophic level")
end
plt


savefig(plt, "manyspeciestimeseries.png")
