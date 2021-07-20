using MetacommunityDynamics
using DynamicGrids
using DynamicGridsGtk
using Dispersal
using Distributions 
using ColorSchemes 
using Plots

consumermodel = 
    Eating{Tuple{:C,:R}}(
        functionalresponse=LotkaVolterra(0.1), 
        dt=0.1) +
    AdjacentBernoulliDispersal{:C}(DispersalKernel(radius=2), 0.5) + 
    LinearMortality{:C}(0.1);

resourcemodel = 
    MetacommunityDynamics.LogisticGrowth{:R}(λ=1.1, K=200., dt=0.1) +
    AdjacentBernoulliDispersal{:R}(DispersalKernel(radius=1), 0.2);

model = resourcemodel + consumermodel


# helper for plotting 
function plot_lv_timeseries(arrayout)
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
end

# wave initial condition 
latticesize = 250
initconsumer = zeros(Biomass, latticesize, latticesize)
initresource = zeros(Biomass,  latticesize, latticesize)


rci = rand(DiscreteUniform(1, latticesize), (50, 2) )
rri = rand(DiscreteUniform(1, latticesize), (300, 2) )

map( i -> initconsumer[i...] = 10., rci)
map( i -> initresource[i...] = 10., rri)


gtkout = GtkOutput((C=initconsumer, R=initresource ), tspan=1:1000, scheme=(ColorSchemes.Blues_5, ColorSchemes.Greens_4),  minval=(0,0), maxval=(3,10),)
sim!(gtkout, model)


arrayout = ArrayOutput((C=initconsumer, R=initresource ), tspan=1:750)
@time sim!(arrayout, model) # > roughly 1s on single core laptor
plot_lv_timeseries(arrayout) # reaches steady state around timestep 1000

gifoutput = GifOutput((C=initconsumer, R=initresource ),
    filename="./docs/static/spicylv.gif", 
    tspan=1:750, 
    fps=25, 
    minval=(0,0), maxval=(3,10),
    scheme = (ColorSchemes.Blues_5, ColorSchemes.Greens_4),
    padval = 100
)
sim!(gifoutput, model)