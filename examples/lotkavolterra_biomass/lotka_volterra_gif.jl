using MetacommunityDynamics
using DynamicGrids
using Distributions 
using ColorSchemes 
using Dispersal: DispersalKernel, OutwardsDispersal
using Plots

consumermodel = 
    Eating{Tuple{:C,:R}}(
        functionalresponse=LotkaVolterra(0.2), 
        dt=0.1) +
        OutwardsDispersal{:C}(DispersalKernel(radius=3)) + 
    #RandomExtinction{:C}(0.1) + 
    LinearMortality{:C}(0.1);

resourcemodel = 
    LogisticGrowth{:R}( λ=1.1, K=200., dt=0.1) +
    OutwardsDispersal{:R}(DispersalKernel(radius=5));

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

initresource = rand(Biomass, Exponential(10.) ,latticesize, latticesize)

initconsumer = zeros(Biomass, latticesize, latticesize)
rci = rand(DiscreteUniform(1, latticesize), (100, 2) )
map( i -> initconsumer[i...] = 10., rci)



arrayout = ArrayOutput((C=initconsumer, R=initresource ), tspan=1:500)
@time sim!(arrayout, model)

max(arrayout[300][:R]...)

plot_lv_timeseries(arrayout) 

gifoutput = GifOutput((C=initconsumer, R=initresource ),
    filename="./docs/static/spicylv.gif", 
    tspan=1:750, 
    fps=25, 
    minval=(0,0), maxval=(10, 30),
    scheme = (ColorSchemes.Blues_5, ColorSchemes.Greens_4),
    padval = 100
)
@time sim!(gifoutput, model)