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



    abstract type MeasurementType end

    struct EnvironmentalMeasurement <: MeasurementType
        value::Array{Number,2}
    end
    struct MetacommunityMeasurement <: MeasurementType
        value::Array{Number,3}
    end

    struct Trait <: MeasurementType end
    struct Abundance <: MeasurementType end
    struct Occupancy <: MeasurementType end

    ### TODO
    #   think about the best data structure for sp/location/time cube
    mutable struct Measurement{T <: EnvironmentalMeasurement}
        value::T
    end


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
    mutable struct DynamicsInstance{T <: DynamicsModel}
        dynamics_model::T
        landscape::Landscape
        settings::SimulationSettings
        has_been_run::Bool
    end
    DynamicsInstance(;  dynamics_model::DynamicsModel= Neutral(),
                        landscape::Landscape = Landscape(),
                        settings::SimulationSettings = SimulationSettings()
                        ) = DynamicsInstance(dynamics_model, landscape, settings, false)

    export DynamicsInstance

    # Include files with constructors for dispersal stuff
    include(joinpath(".", "simulation.jl"))
    using .MCDSimulation
    export simulate


end
