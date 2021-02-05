module MetacommunityDynamicsVisualization
    using ..MetacommunityDynamics
    using ..Dynamics
    using Plots
    locations_plots = []

    function plot_trajectory_across_locations(traj::MetacommunityTrajectory)
        nl = nlocations(traj)
        ns = nspecies(traj)
        nt = ntimepoints(traj)

        locations_plots = []

        for l = 1:nl
            p = plot(legend=:none, dpi=300, aspectratio=1, ylim=(0,1.2),  title = "location $l")

            for s = 1:ns
                plot!(1:nt, traj[l,s,:])
            end
            push!(locations_plots, p)
        end
        return plot(locations_plots..., layout=nl)
    end
    export plot_trajectory_across_locations
end
