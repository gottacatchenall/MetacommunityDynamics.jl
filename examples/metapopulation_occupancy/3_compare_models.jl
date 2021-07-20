using MetacommunityDynamics
using Dispersal
using DataFrames
using Plots
using Distributions

classiclevinsmodel = (; C,E, kw...) -> 
    LevinsColonization{:O}(probability=C) + 
    RandomExtinction{:O}(probability=E);


spatiallyexplicitlevinsmodel = (; C,E, kw...) -> 
    SpatiallyExplicitLevinsColonization{:O}(probability=C) + 
    AbioticExtinction{:O}(:A, baseprobability=E);


paramset = (
    C = 0:0.01:1,
    E = 0:0.01:1,
)


pops = generate(PoissonProcess, 20)
scatter(pops[:,1], pops[:,2], aspectratio=1, ms=[rand(Exponential(3)) for i in 1:20])


popsgrid = pointstogrid(pops, gridsize=100)
areas = generate(StaticEnvironmentalLayer, zeros(size(popsgrid)), Exponential(3), mask=popsgrid)
heatmap(areas)

initocc = rand(Occupancy, 0.8, 5,5)
arrayout = ArrayOutput((O=initocc, A=areas ), tspan=1:3)
sim!(arrayout, rs)

