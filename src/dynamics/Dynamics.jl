module Dynamics
    using ..MetacommunityDynamics
    using ..Landscapes
    using ..Metawebs
    using DataFrames
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

    Base.size(trajectory::MetacommunityTrajectory) = Base.size(trajectory.trajectory)

    Base.setindex!(trajectory::MetacommunityTrajectory, state::Array, time_index::Int) = begin 
        trajectory.trajectory[:,:,time_index] =  state
    end
    Base.setindex!(trajectory::MetacommunityTrajectory, value::Number, location_index::Int, species_index::Int, time_index::Int) = begin 
        trajectory.trajectory[location_index, species_index,time_index] = value
    end

    Base.getindex(trajectory::MetacommunityTrajectory, time_index::Int) = (trajectory.trajectory[:,:,time_index])
    Base.getindex(trajectory::MetacommunityTrajectory, a,b,c) = trajectory.trajectory[a,b,c]
    Base.firstindex(trajectory::MetacommunityTrajectory) = 1

    Base.length(trajectory::MetacommunityTrajectory) = length(trajectory.trajectory[1,1,:])
    Base.iterate(trajectory::MetacommunityTrajectory) = Base.iterate(trajectory.trajectory)
    Base.iterate(trajectory::MetacommunityTrajectory, i) =Base.iterate(trajectory.trajectory, i)
    Base.show(io::IO, trajectory::MetacommunityTrajectory) = println(io, "metacommunity dynamics trajectory with ", length(trajectory), " timesteps" )

    nlocations(trajectory::MetacommunityTrajectory) = size(trajectory)[1]
    nspecies(trajectory::MetacommunityTrajectory) = size(trajectory)[2]
    ntimepoints(trajectory::MetacommunityTrajectory) = size(trajectory)[3]
    export nlocations, nspecies, ntimepoints

    # interface to dataframe

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

    export MetacommunityTrajectory




    # Include files with constructors for dispersal stuff
    include(joinpath(".","DriftModels/abundance","NeutralHomogenous.jl"))
    using .AbundanceNeutral
    export AbundanceNeutralModel, AbundanceNeutralParameters

    # Include files with constructors for dispersal stuff
    include(joinpath(".", "simulation.jl"))
    using .MCDSimulation
    export simulate


end
