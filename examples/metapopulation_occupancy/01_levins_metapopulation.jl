using MetacommunityDynamics
using DynamicGrids
using Plots

model = LevinsColonization{:O}(probability=0.3) + 
    RandomExtinction{:O}(probability=0.1);

initialoccupancy = rand(Occupancy, 0.5, 5,5)
arrayoutput = ArrayOutput((O=initialoccupancy, ), tspan=1:3)
sim!(arrayoutput, model)
