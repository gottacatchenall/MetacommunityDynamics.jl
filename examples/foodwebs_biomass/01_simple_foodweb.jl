using MetacommunityDynamics
using DynamicGrids
using Plots
using Distributions
using Dispersal: Moore, DispersalKernel
using EcologicalNetworks: nichemodel, mpnmodel, trophic_level, UnipartiteNetwork

number_of_species = 50
connectance = 0.1
forbiddenlinkprob = 0.3

foodweb = mpnmodel(number_of_species, connectance, forbiddenlinkprob)
heatmap(Matrix(foodweb.edges), legend=:none, aspectratio=1)


speciespool = DiscreteUnipartiteSpeciesPool(Symbol.(foodweb.S), Matrix(foodweb.edges)) # move these type changes to a method
trophicdict = trophic_level(foodweb)  # returns a dictionary 

resourcenames = filter(s -> trophicdict[String(s)] < 2.0, species(speciespool))
consumernames = filter(s -> trophicdict[String(s)] >= 2.0, species(speciespool))
    
consumermodel = 
    FoodWebEating(consumernames, resourcenames, LotkaVolterra(0.2), speciespool.metaweb) +
    AdjacentBernoulliDispersal(consumernames, DispersalKernel(radius=1), 0.1) +
    RandomExtinction(consumernames, probability=0.1) +
    LinearMortality(consumernames, 0.01);

plantmodel = 
    LogisticGrowth(resourcenames) +
    AdjacentBernoulliDispersal(resourcenames, DispersalKernel(radius=2), 0.1) ;

fullmodel = consumermodel + plantmodel;



dim = (40,40)
ntimesteps = 300

init = NamedTuple(merge(
    rand(Biomass, resourcenames, Exponential(10), dim...),
    rand(Biomass, consumernames, Exponential(10), dim...)));

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

plot(mat', legend=:outerright, ylims=(0.001, 2e5),frame=:box, dpi=150)
yaxis!(:log10)

xaxis!("timestep")
yaxis!("log10(biomass)") 
savefig("manyspecies.png")

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





#anim = @animate for i ∈ 1:ntimesteps
#    heatmap(biomass[i], title="time $i", aspectratio=1, frame=:box, xlims=(1,sz), ylims=(1,sz), clims=(0, max(biomass[end]...)), c=:viridis)
#end

#gif(anim, "reallylarg.gif" , fps=15)



anim = @animate for i ∈ 1:ntimesteps
    heatmap(speciesrichness[i], 
        title="time $i", 
        aspectratio=1, 
        frame=:box, 
        xlims=(1,sz), 
        ylims=(1,sz), 
        clims=(0, number_of_species), 
        c=:viridis,
        colorbar_title="species richness")
end

gif(anim, "mpn_richness.gif" , fps=15)