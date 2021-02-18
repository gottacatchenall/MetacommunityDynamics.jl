"""
    AbundanceNeutralModel
    --------------------------------------------

    AbundanceNeutralModel defines a model where the abundance each species at each location changes according to random fluctuations. In this model,
    the distribution of the strength of random fluctuations (σ) is the same for all locations, times, and species.

    At each timestep, the abundance A_{ij}(t) of species i at location j at time t is given by
     A_{ij}(t) = A_{ij}(t-1) + delta where delta sim Normal(0, σ)
    independently for all times.
    --------------------------------------------
"""

module AbundanceNeutral
    using ..Dynamics
    using ..Landscapes
    using ..Metawebs
    using ..MetacommunityDynamics.MCDParams
    using Distributions: Uniform, Normal

    struct AbundanceNeutralParameters <: DynamicsParameterSet
         # A vector of standard deviation (σᵢ) for each species abundance Nᵢ(t+1) = N(t) +  σᵢ(t), where σᵢ(t) ∼ Normal(σᵢ)
        σ::Parameter
    end
    AbundanceNeutralParameters(;
        metaweb=Metaweb(),
        σ = Parameter(Normal(0, 0.3))
    ) = AbundanceNeutralParameters(σ)
    

    export AbundanceNeutralParameters

    struct AbundanceNeutralModel <: DynamicsModel
        landscape::Landscape
        metaweb::Metaweb
        settings::SimulationSettings
        parameters::AbundanceNeutralParameters
    end
    AbundanceNeutralModel(;
        landscape=Landscape(),
        metaweb = Metaweb(),
        settings = SimulationSettings(),
        parameters= AbundanceNeutralParameters(metaweb=metaweb)
    ) = AbundanceNeutralModel(landscape, metaweb, settings, parameters)

    Base.show(io::IO, model::AbundanceNeutralModel) = print("abundance neutral model with ", size(model.metaweb), " species and ", size(model.landscape), " locations")

    function (model::AbundanceNeutralModel)()

        trajectory = MetacommunityTrajectory(
            number_of_timesteps=model.settings.number_of_timesteps,
            metaweb = model.metaweb,
            landscape = model.landscape
        )

        trajectory[1] = [rand(Uniform()) for i in 1:size(model.landscape), j in 1:size(model.metaweb)]

        n_t = length(trajectory)
        for t in 2:n_t
            model(trajectory, t-1, t)
        end
        return trajectory
    end

    function (model::AbundanceNeutralModel)(trajectory::MetacommunityTrajectory, old_time::Int, new_time::Int) where {T <: Number}
        # species x location matrix
        num_species = size(model.metaweb)
        num_locations = size(model.landscape)

        for s in 1:num_species
            for l in 1:num_locations
                # extinciton is an absorbing boundary condition
                old_state = trajectory[l,s,old_time]
                new_state = 0
                if old_state >  0
                    new_state = max(old_state + rand(model.parameters.σ), 0)
                end
                trajectory[l,s,new_time] = new_state
            end
        end
    end

    export AbundanceNeutralModel
end
