# MetacommunityDynamics.jl

A Julia library for simulating the dynamics of species interaction
networks across space and time. Part of [EcoJulia](http://github.com/EcoJulia),
and built on top of [DynamicGrids](http://github.com/cesaraustralia/DynamicGrids.jl).



This software is designed to simulate how the composition of ecological communities changes over time.


# Examples

## Lotka-Volterra 



The Lotka-Volterra (LV) system is a set of coupled differential equations
which describe a system of consumers and resources (also called predators and prey).

```
using MetacommunityDynamics
using DynamicGrids
using Dispersal: OutwardsDispersal
using Distributions 
consumermodel = 
    Eating{Tuple{:C,:R}}(
        functionalresponse=LotkaVoterra(0.1), 
        dt=0.1) +
    OutwardsDispersal{:C}() + 
    LinearMortality{:C}(0.3);

resourcemodel = 
    LogisticGrowth{:R}(λ=2, K=200., dt=0.1) +
    LinearMortality{:R}(0.01) + 
    OutwardsDispersal{:R}();

model = resourcemodel + consumermodel

gridsize = 100
initconsumer = rand(Biomass, Uniform(10, 30), gridsize, gridsize)
initresource = rand(Biomass, Uniform(10, 90), gridsize, gridsize)

arrayout = ArrayOutput((C=initconsumer, R=initresource ), tspan=1:300)
sim!(arrayout, model)
```

and to plot

```
using Plots

Cs = Float64[]
Rs = Float64[]
for t in arrayout
    push!(Cs, sum(t[:C]))
    push!(Rs, sum(t[:R]))
end

plot(1:length(Cs),Cs, label="consumer")
plot!(1:length(Rs),Rs, label="resource")
xlabel!("time")
ylabel!("biomass")

```

![LV](./docs/static/lv.png)

## Food Web

```
using MetacommunityDynamics
using DynamicGrids
using Plots
using Distributions
using Dispersal: Moore, DispersalKernel
using EcologicalNetworks: nichemodel, mpnmodel, trophic_level, UnipartiteNetwork, degree, richness
using ColorSchemes

number_of_species = 50
connectance = 0.05
forbiddenlinkprob = 0.5

foodweb = mpnmodel(number_of_species, connectance, forbiddenlinkprob)

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




```


![this is kind of neat](./examples/foodwebs_biomass/foodwebtraj.png)


## Contributing

Open a PR or issue
