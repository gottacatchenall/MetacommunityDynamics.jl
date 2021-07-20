using MetacommunityDynamics
using DynamicGrids
using DynamicGridsGtk
using Dispersal
using Distributions 
using ColorSchemes 
using Plots

consumermodel = 
    Eating{Tuple{:C,:R}}(
        functionalresponse=LotkaVolterra(0.3), dt=0.1) +
    AdjacentBernoulliDispersal{:C}(DispersalKernel(radius=2), 0.4) +
    RandomExtinction{:C}(0.1);


resourcemodel = 
    MetacommunityDynamics.LogisticGrowth{:R}(λ=1.4, K=10., dt=0.1) +
    AdjacentBernoulliDispersal{:R}(DispersalKernel(radius=6), 0.2) + 
    RandomExtinction{:C}(0.05);

model = resourcemodel + consumermodel

latticesize = 100
initconsumer = zeros(Biomass, latticesize,latticesize)
initresource = zeros(Biomass, latticesize,latticesize)

initr = 50000
initc = 5000

map(i -> initresource[i...] = 10., rand(DiscreteUniform(1, latticesize), (initr,2)))
map(i -> initconsumer[i...] = 5., rand(DiscreteUniform(1, latticesize), (initc,2)))


arrayout = ArrayOutput((C=initconsumer, R=initresource ), tspan=1:1500)
@time sim!(arrayout, model)     

gtkout = GtkOutput((C=initconsumer, R=initresource ), tspan=1:1000, scheme=(ColorSchemes.Blues_5, ColorSchemes.Greens_4),  minval=(0,0), maxval=(3,10),)
sim!(gtkout, model)



## Ploting
Cs = zeros(Float64, length(arrayout))
Rs = zeros(Float64, length(arrayout))
for (i,fr) in enumerate(arrayout)
    Cs[i] = sum(fr[:C])
    Rs[i] = sum(fr[:R])
end
plot(1:length(Cs),Cs, label="consumer")
plot!(1:length(Rs),Rs, label="resource")
xlabel!("time")
ylabel!("biomass")


