# intro about metapopulations and occupancy dynamics

using MetacommunityDynamics
using DynamicGrids
using DynamicGridsGtk
using Dispersal
using Distributions 
using ColorSchemes 
using Plots

levinsmodel = 
    RandomExtinction{:O}(0.1) + 
    LevinsColonization{:O}(0.3)

latticesize = 100
initocc = 0.2
init = fill(rand() < initocc, latticesize,latticesize)

arrayout = ArrayOutput((C=initconsumer, R=initresource ), tspan=1:500)
@time sim!(arrayout, model) 
