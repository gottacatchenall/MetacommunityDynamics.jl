module Dynamics
    using ..MetacommunityDynamics
    using ..Landscapes
    using ..Metawebs
    using Distributions

    """
        DynamicsModel
        ----------------------------------------------------
        An abstract type
    """
    abstract type DynamicsModel end
    export DynamicsModel

    abstract type DynamicsParameterSet end
    export DynamicsParameterSet

    """
        SimulationSettings()
        ----------------------------------------------------
        A parametric struct which contains parameters related
        to simulating dynamics.
    """
    struct SimulationSettings
        number_of_timesteps::Int64
        timestep_width::Float64
        log_frequency::Int64
    end
    SimulationSettings(; number_of_timesteps = 100, timestep_width=0.1, log_frequency=10) =
        SimulationSettings(number_of_timesteps, timestep_width, log_frequency)
    export SimulationSettings



    abstract type Trajectory end
    export Trajectory

    struct EnvironmentalTrajectory <: Trajectory
        value::Array{Number,2}
    end
    export EnvironmentalTrajectory



    struct MetacommunityTrajectory{T}
        trajectory::Array{T,3}
    end
    MetacommunityTrajectory(;
        number_of_timesteps::Int64 = 100,
        metaweb::Metaweb=Metaweb(),
        landscape::Landscape = Landscape()
    ) = MetacommunityTrajectory( zeros(size(landscape), size(metaweb), number_of_timesteps))



    # interface to dataframe
"""
    DataFrames.DataFrame(trajectory::MetacommunityTrajectory) = begin
            nt = length(trajectory)
            nl = size(trajectory[1])[1]
            ns = size(trajectory[1])[2]

            total_number_points = nt*nl*ns

            df = DataFrame(time=zeros(total_number_points), location=zeros(total_number_points), species=zeros(total_number_points), value=zeros(total_number_points))

            row_count = 1
            for t = 1:nt, l = 1:nl, s = 1:ns
                df.time[row_count] = t
                df.location[row_count] = l
                df.species[row_count] = s
                df.value[row_count] = trajectory[l,s,t]

                row_count += 1
            end

            return df
    end
"""



    include(joinpath(".", "interfaces.jl"))
    export MetacommunityTrajectory
    export nlocations, nspecies, ntimepoints



    #dispersal
    include(joinpath(".", "dispersal", "Dispersal.jl"))
    using .Dispersal
    export DispersalPotential

    #
    include(joinpath(".", "environment", "Environment.jl"))
    using .Environment


    # Include files with constructors for dispersal stuff
    include(joinpath(".","drift", "abundance","NeutralHomogenous.jl"))
    using .AbundanceNeutral
    export AbundanceNeutralModel, AbundanceNeutralParameters

    # Include files with constructors for dispersal stuff
    include(joinpath(".", "simulation.jl"))
    using .MCDSimulation
    export simulate


end
