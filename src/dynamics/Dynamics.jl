module Dynamics
    using ..MetacommunityDynamics
    using ..Landscapes

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


    abstract type Measurement end
    struct Abundance <: Measurement
        dimensions::Int
    end
    Abundance() = Abundance(1)


    mutable struct DynamicsTrajectory
        state::Array{Float64} 
    end

    DynamicsTrajectory(;locations=LocationSet(), settings=SimulationSettings()) = begin
        dimensions::Int = size(locations)
        number_of_timesteps::Int = settings.number_of_timesteps
        log_frequency::Int = settings.log_frequency
        delta_time::Float64 = settings.timestep_width
        number_logged_timepoints::Int = Int(floor(number_of_timesteps/log_frequency))
        
        empty_trajectory::Array{Float64} = zeros(number_logged_timepoints, dimensions)
        return DynamicsTrajectory(empty_trajectory)
    end
    export DynamicsTrajectory



    # Include files with constructors for dispersal stuff
    include(joinpath(".", "Neutral.jl"))
    using .NeutralModel
    export NeutralModel, Neutral


    """
        DynamicsInstance()
        ----------------------------------------------------
        An instance of a treatment, which contains the resulting
        abundance matrix.
    """
    struct DynamicsInstance{T <: DynamicsModel}
        dynamics_model::T
        landscape::Landscape
        settings::SimulationSettings
        trajectory::DynamicsTrajectory
        has_been_run::Bool
    end
    DynamicsInstance(;  dynamics_model::DynamicsModel= Neutral(),
                        landscape::Landscape = Landscape(),
                        settings::SimulationSettings = SimulationSettings()
                        ) = DynamicsInstance(dynamics_model, landscape, settings, DynamicsTrajectory(settings=settings, locations=landscape.locations), false)

    export DynamicsInstance
end
