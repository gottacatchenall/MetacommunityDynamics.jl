using MetacommunityDynamics
using DynamicGrids
using Plots
using Distributions 

# Spatially explicit levins model 

rs = SpatiallyExplicitLevinsColonization{:O}(probability=0.3) + 
     AbioticExtinction{:O}(:A, baseprobability=0.1);

pops = pointstogrid(generate(PoissonProcess, 20), gridsize=100)

areas = generate(StaticEnvironmentalLayer, similar(pops), Exponential(3), mask=pops)

areas = rand(5,5)

initocc = rand(Occupancy, 0.8, 5,5)
arrayout = ArrayOutput((O=initocc, A=areas ), tspan=1:3)
sim!(arrayout, rs)

