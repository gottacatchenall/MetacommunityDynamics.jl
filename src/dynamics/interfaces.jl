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
