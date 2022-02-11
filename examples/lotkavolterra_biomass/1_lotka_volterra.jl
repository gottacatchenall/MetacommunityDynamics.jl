using MetacommunityDynamics
using DynamicGrids
using Dispersal
using Distributions 
using ColorSchemes 
using Plots

consumermodel = 
    Eating{Tuple{:C,:R}}(
        functionalresponse=LotkaVolterra(0.3), 
        dt=0.1) +
    LinearMortality{:C}(0.1);

resourcemodel = 
    MetacommunityDynamics.LogisticGrowth{:R}(λ=1.4, K=10., dt=0.1);

model = resourcemodel + consumermodel

latticesize = 1
initconsumer = zeros(Biomass, latticesize,latticesize)
initresource = zeros(Biomass, latticesize,latticesize)


initresource[1] = 2.
initconsumer[1] = 0.5

arrayout = ArrayOutput((C=initconsumer, R=initresource ), tspan=1:500)
@time sim!(arrayout, model) 


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
