
@kwdef struct Observer
    frequency = 5
    measurement_error = Normal(0,0.02)
end 

### TODO
# Observed data points should absolutely be a struct instead of returns as a
# method

@kwdef struct Observation{T<:Number}
    observer::Observer
    data::Array{T}
end



function observe(observer::Observer, traj::Trajectory)
    ts = timeseries(traj)

    obs_times = 1:observer.frequency:length(traj)

    observations = []

    for t in obs_times
        push!(observations, [x + rand(observer.measurement_error) for x in ts[t]])
    end
    hcat(observations...)
end 

function observe(observer::Observer, x::Number)
    return x += rand(observer.measurement_error)
end 

