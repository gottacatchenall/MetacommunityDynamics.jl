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

    struct MetacommunityState
        state::Array{Number,2}
    end
    MetacommunityState(; metaweb::Metaweb=Metaweb(), landscape::Landscape=Landscape()) = MetacommunityState(zeros(size(landscape), size(metaweb)))
    Base.size(state::MetacommunityState) = size(state.state)
    Base.getindex(state::MetacommunityState, location_index::Int, species_index::Int) = state.state[location_index, species_index]
    Base.setindex!(state::MetacommunityState, value, location_index::Int, species_index::Int) = Base.setindex!(state.state, value, location_index, species_index)



    Base.show(io::IO, state::MetacommunityState) = println(io, size(state)[1], "x", size(state)[2], " metacommunity state")

    export MetacommunityState

    struct MetacommunityTrajectory <: Trajectory
        trajectory::Vector{MetacommunityState}
    end

    Base.length(trajectory::MetacommunityTrajectory) = length(trajectory.trajectory)
    MetacommunityTrajectory(; number_of_timesteps::Int64 = 100, metaweb::Metaweb=Metaweb(), landscape::Landscape = Landscape()) = MetacommunityTrajectory(collect(MetacommunityState(;metaweb = Metaweb(), landscape = Landscape()) for i in 1:number_of_timesteps))

    Base.iterate(trajectory::MetacommunityTrajectory) =Base.iterate(trajectory.trajectory)
    Base.iterate(trajectory::MetacommunityTrajectory, i) =Base.iterate(trajectory.trajectory, i)

    Base.getindex(trajectory::MetacommunityTrajectory, time_index) = trajectory.trajectory[time_index]



    Base.show(io::IO, trajectory::MetacommunityTrajectory) = println(io, "metacommunity dynamics trajectory with ", length(trajectory), " timesteps" )

    export MetacommunityTrajectory




    # Include files with constructors for dispersal stuff
    include(joinpath(".","DriftModels/abundance","NeutralHomogenous.jl"))
    using .AbundanceNeutral
    export AbundanceNeutralModel

    # Include files with constructors for dispersal stuff
    include(joinpath(".", "simulation.jl"))
    using .MCDSimulation
    export simulate


end
