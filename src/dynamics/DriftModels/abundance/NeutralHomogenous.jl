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
    using Distributions: Normal

    struct AbundanceNeutralParameters <: DynamicsParameterSet
         # A vector of standard deviation (σᵢ) for each species abundance Nᵢ(t+1) = N(t) +  σᵢ(t), where σᵢ(t) ∼ Normal(σᵢ)
        σ::Parameter
    end
    AbundanceNeutralParameters(;
        metaweb=Metaweb(),
        σ = Parameter(Normal(0.3, 0))
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

    function (model::AbundanceNeutralModel)()
        trajectory = MetacommunityTrajectory(number_of_timesteps=model.settings.number_of_timesteps)

        n_t = length(trajectory ) - 1
        for i in 1:n_t
            model(trajectory[i], trajectory[i+1])
        end
        return trajectory
    end

    function (model::AbundanceNeutralModel)(old_state::MetacommunityState, new_state::MetacommunityState)
        # species x location matrix
        num_species = size(model.metaweb)
        num_locations = size(model.landscape)

        for s in 1:num_species
            for l in 1:num_locations
                # extinciton is an absorbing boundary condition
                if old_state[l,s] > 0
                    new_state[l,s] = old_state[l,s] + rand(model.σ[p])
                else
                    new_state[l,s] = 0
                end
            end
        end
    end

    export AbundanceNeutralModel
end
