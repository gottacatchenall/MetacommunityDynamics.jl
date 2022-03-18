using MetacommunityDynamics
using DynamicGrids
using Plots
using Distributions
using Dispersal: Moore, DispersalKernel
using EcologicalNetworks: mpnmodel, trophic_level, UnipartiteNetwork, degree, richness
using ColorSchemes

#= 
number_of_species = 5
connectance = 0.3
forbiddenlinkprob = 0.5

foodweb = mpnmodel(number_of_species, connectance, forbiddenlinkprob)
heatmap(Matrix(foodweb.edges), legend=:none, aspectratio=1)
=#

foodweb = UnipartiteNetwork(Bool[0 1 ; 0 0])

sp = DiscreteUnipartiteSpeciesPool(Symbol.(foodweb.S), Matrix(foodweb.edges)) # move these type changes to a method
trophicdict = trophic_level(foodweb)  # returns a dictionary 

resource = filter(s -> trophicdict[String(s)] == 1, species(sp))
consumers = filter(s -> trophicdict[String(s)] > 1, species(sp))
    
consumermodel = 
    FoodWebEating(sp, LotkaVolterra(0.2)) +
    AdjacentBernoulliDispersal(consumers, DispersalKernel(radius=1), 0.1) +
 #   RandomExtinction(consumers, probability=0.1) #+
    LinearMortality(consumers, 0.1);

plantmodel = 
    LogisticGrowth(resource, λ=1.4, K=100.) 
    AdjacentBernoulliDispersal(resource, DispersalKernel(radius=2), 0.1) ;

fullmodel = consumermodel + plantmodel;



dim = (5,5)
ntimesteps = 1000

init = NamedTuple(merge(
    rand(Biomass, resource, Exponential(10), dim...),
    rand(Biomass, consumers, Exponential(100), dim...)));

arrayout = ArrayOutput(init, tspan=1:ntimesteps)
@time sim!(arrayout, fullmodel); 




"""
    plots : 
"""

mat = zeros(2, ntimesteps)

spnames = []
for t = 1:ntimesteps
  ind = 1

  for (k,v) in zip(keys(arrayout[t]), values(arrayout[t]))
    mat[ind, t] = sum(v)
    push!(spnames, k)
    ind += 1
  end  
end



plt = plot()
xaxis!(plt, xticks=[i for i in 0:50:ntimesteps],"timestep")
yaxis!(plt, "biomass") 
yaxis!(plt)
for s in 1:2
    speciesname = spnames[s]
    thiscol = get(ColorSchemes.thermal, trophicdict[String(speciesname)]/max(values(trophicdict)...))

    @show thiscol, speciesname, trophicdict[String(speciesname)]
    plot!(plt, 1:ntimesteps, mat[s,:], la=0.7, lw=3, label="trophic $(trophicdict[String(speciesname)])", c=thiscol, colorbar_title="trophic level")
end
plt


savefig(plt, "manyspeciestimeseries.png")

"""
# ----
sz = dim[1]
ntimesteps = ntimesteps

biomass =  [zeros(sz,sz) for i in 1:ntimesteps]
speciesrichness = [zeros(sz,sz) for i in 1:ntimesteps]
for t in 1:ntimesteps
    now = arrayout[t]

    for (sp, abundmatrix) in zip(keys(now), values(now))
        for x in 1:sz, y in 1:sz
            if abundmatrix[x,y] > 0.0001
                speciesrichness[t][x,y] += 1
                biomass[t][x,y] += abundmatrix[x,y]
            end
        end
    end
end

"""


