using MetacommunityDynamics
using Distributions


model = MetacommunityDynamics.Dynamics.AbundanceNeutralModel(
    landscape = Landscape(locations=LocationSet(numberOfLocations=20)),
    metaweb = Metaweb(numberOfSpecies=5),
    parameters= MetacommunityDynamics.Dynamics.AbundanceNeutralParameters(σ = Parameter(Distributions.Normal(0, 0.1)))
)


trajectory = model()

p = plot_trajectory_across_locations(trajectory)



using DataFrames
using StatsPlots
plot(trajectory[3].state, layout=30, dpi=600)


data = DataFrame(trajectory)
@df data scatter(:time, :value,
        group = :location,
        layout = 5,
        linewidth=0.1,
        linealpha=0.4,
        label = "",
        frame = :box,
        size=(1000,1000))
