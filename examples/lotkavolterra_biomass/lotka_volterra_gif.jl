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
        OutwardsDispersal{:C}(DispersalKernel(radius=1)) + 
    LinearMortality{:C}(0.1);

resourcemodel = 
    LogisticGrowth{:R}( λ=1.1, K=200., dt=0.1) +
    OutwardsDispersal{:R}(DispersalKernel(radius=2));

model = resourcemodel + consumermodel


# helper for plotting 
function plot_lv_timeseries(arrayout)
    Cs = Float64[]
    Rs = Float64[]
    for t in arrayout
        push!(Cs, sum(t[:C]))
        push!(Rs, sum(t[:R]))
    end

    plot(Rs, Cs)
    xlabel!("total resource biomass")
    ylabel!("total consumer biomass")
end

# wave initial condition 
latticesize = 50

initresource = rand(Biomass, Exponential(10.) ,latticesize, latticesize)

initconsumer = zeros(Biomass, latticesize, latticesize)
rci = rand(DiscreteUniform(1, latticesize), (100, 2) )
map( i -> initconsumer[i...] = 10., rci)



arrayout = ArrayOutput((C=initconsumer, R=initresource ), tspan=1:500)
@time sim!(arrayout, model)

plot_lv_timeseries(arrayout) 

gifoutput = GifOutput((C=initconsumer, R=initresource ),
    filename="lv.gif", 
    tspan=1:300, 
    fps=25, 
    minval=(0,0), maxval=(10, 30),
    scheme = (ColorSchemes.Blues_5, ColorSchemes.Greens_4),
    padval = 100
)
@time sim!(gifoutput, model)