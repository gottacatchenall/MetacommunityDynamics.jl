
using DynamicGrids
using MetacommunityDynamics

initx = rand(Occupancy, 5,5)

arrayout = ArrayOutput((X=initx, ), tspan=1:3)
rule = Ruleset(RandomColonization{:X}(probability=0.3) , RandomExtinction{:X}(probability=0.1) )
sim!(arrayout, rule)
