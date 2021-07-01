# intro about metapopulations and occupancy dynamics

using MetacommunityDynamics
using DynamicGrids
using DynamicGridsGtk
using Dispersal
using Distributions 
using ColorSchemes 
using Plots



levinsmodel = RandomExtinction{:O}(0.1) + LevinsColonization{:O}(0.3)


latticesize = 100

ic, ir = 10.,1.

initconsumer = zeros(Biomass, latticesize,latticesize)
initresource = zeros(Biomass, latticesize,latticesize)




arrayout = ArrayOutput((C=initconsumer, R=initresource ), tspan=1:500)
@time sim!(arrayout, model) 
