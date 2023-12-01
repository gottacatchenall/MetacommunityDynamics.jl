struct TrophicLotkaVolterra{S<:Spatialness} <: Model{Community,Biomass,S,Continuous}
    r::Parameter
    A::Parameter
end


initial(::TrophicLotkaVolterra) = [0.1, 1.0]
numspecies(lv::TrophicLotkaVolterra) = length(lv.r)

function ∂u(::TrophicLotkaVolterra, u, θ)
    r, A = θ
    @fastmath u .* (r .+ A*u)
end


# ====================================================
#
#   Constructors
#
# =====================================================

function TrophicLotkaVolterra(;
    r::Vector = [-0.1, 0.02],
    A::Matrix = [0 0.2;
                 -0.1 0]
)
    TrophicLotkaVolterra{Local}(
        Parameter(r),
        Parameter(A)
    )
end



# ====================================================
#
#   Plots
#   
# =====================================================


function replplot(::TrophicLotkaVolterra{Local}, traj::Trajectory) 
    u = timeseries(traj)
    ymax = max([extrema(x)[2] for x in timeseries(traj)]...)
    ts(s) = [mean(u[t][s,:]) for t in 1:length(traj)]
    p = lineplot( ts(1), 
        xlabel="time (t)", 
        ylabel="Biomass", 
        width=80,
        ylim=(0,ymax))

    for i in 2:length(u[1])
        lineplot!(p, ts(i))
    end 
    p
end
