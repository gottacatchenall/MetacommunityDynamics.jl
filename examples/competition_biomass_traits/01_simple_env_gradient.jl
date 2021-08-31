using Plots
using NeutralLandscapes
using EcologicalNetworks
using MetacommunityDynamics

sidelength = 50

# a top to bottom grid of an environmental variable

temp = rand(PlanarGradient(180), sidelength, sidelength)
heatmap(temp, 
    c=:thermal,
    aspectratio=1,
    frame=:box,
    size=(500,500)
    )

speciesA = 
    LogisticGrowth{:A}(λ=1.4, K=10., dt=0.1) +
    AbioticExtinction{:A}(temp);

speciesB = 
    LogisticGrowth{:B}(λ=1.4, K=10., dt=0.1) +
    AbioticExtinction{:B}(temp.*-1 .+ 1);

fullmodel = speciesA + speciesB



ae = AbioticExtinction{:B}(temp.*-1 .+ 1);
