module Dynamics
    using ..MetacommunityDynamics
    using ..Landscapes
    using ..Metawebs

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

    struct MetacommunityTrajectory <: Trajectory
        value::Array{Number,3}
    end
    export EnvironmentalTrajectory




    # Include files with constructors for dispersal stuff
    include(joinpath(".","DriftModels/abundance","NeutralHomogenous.jl"))
    using .NeutralModel
    export NeutralModel, Neutral

    # Include files with constructors for dispersal stuff
    include(joinpath(".", "simulation.jl"))
    using .MCDSimulation
    export simulate


end
