using MetacommunityDynamics
using DynamicGrids
using Dispersal
using Distributions 
using ColorSchemes 
using ProfileView
using Plots

consumermodel = 
    Eating{Tuple{:C,:R}}(
        functionalresponse=LotkaVolterra(0.3), dt=0.1) +
    AdjacentBernoulliDispersal{:C}(DispersalKernel(radius=2), 0.6) +
    LinearMortality{:C}(0.07);

resourcemodel = 
    MetacommunityDynamics.LogisticGrowth{:R}(λ=1.4, K=10., dt=0.1)+
    AdjacentBernoulliDispersal{:R}(DispersalKernel(radius=6), 0.1);

model = resourcemodel + consumermodel

latticesize = 5
initconsumer = zeros(Biomass, latticesize,latticesize)
initresource = zeros(Biomass, latticesize,latticesize)

initr = 580
initc = 50

map(i -> initresource[i...] = 10., rand(DiscreteUniform(1, latticesize), (initr,2)))
map(i -> initconsumer[i...] = 5., rand(DiscreteUniform(1, latticesize), (initc,2)))


arrayout = ArrayOutput((C=initconsumer, R=initresource ), tspan=1:1000)
# @time sim!(arrayout, model) 

ProfileView.@profview sim!(arrayout, model) 


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

