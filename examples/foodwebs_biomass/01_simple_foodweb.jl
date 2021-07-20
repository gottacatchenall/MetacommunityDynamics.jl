using MetacommunityDynamics
using DynamicGrids
using Plots
using Distributions
using Dispersal: Moore, DispersalKernel
using EcologicalNetworks: nichemodel, mpnmodel, trophic_level, UnipartiteNetwork, degree, richness
using EcologicalNetworksPlots
using ColorSchemes


number_of_species = 50
connectance = 0.05
forbiddenlinkprob = 0.5

foodweb = mpnmodel(number_of_species, connectance, forbiddenlinkprob)
heatmap(Matrix(foodweb.edges), legend=:none, aspectratio=1)



function foodwebplot(N)
    I = initial(FoodwebInitialLayout, N)
    L = SpringElectric(1.2; gravity=0.05)
    L.move = (true, false)
    for step in 1:(100richness(N))
      position!(L, I, N)
    end
    plot(I, N, la=0.9, frame=:box, dpi=300)
    scatter!(I, N, nodefill=trophic_level(N), nodesize=degree(N), c=:YlGn)
end
foodwebplot(foodweb)
savefig("foodweb.png")

speciespool = DiscreteUnipartiteSpeciesPool(Symbol.(foodweb.S), Matrix(foodweb.edges)) # move these type changes to a method
trophicdict = trophic_level(foodweb)  # returns a dictionary 

resource = filter(s -> trophicdict[String(s)] == 1, species(speciespool))
consumers = filter(s -> trophicdict[String(s)] > 1, species(speciespool))
    
consumermodel = 
    FoodWebEating(consumers, resource, LotkaVolterra(0.2), metaweb(speciespool)) +
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


savefig(plt, "mpn_timeseries.png")

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





anim = @animate for i ∈ 1:ntimesteps
    heatmap(biomass[i], title="time $i",  colorbar_title="biomass",  aspectratio=1, frame=:box, xlims=(1,sz), ylims=(1,sz), clims=(0, max(biomass[end]...)), c=:viridis)
end

gif(anim, "mpnbiomass.gif" , fps=15)



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