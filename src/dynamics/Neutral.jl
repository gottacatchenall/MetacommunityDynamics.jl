"""
    NeutralModel
    --------------------------------------------
"""

module NeutralModel
    using ..Dynamics
    using ..MetacommunityDynamics.MCDParams

    """
        NeutralParameters
        -----------------------------------------------------------
        A parameter bundle for the Ricker model.
    """
    struct NeutralParameters <: DynamicsParameterSet
        σ::Vector{Parameter}   # A vector of standard deviation (σᵢ) for each species abundance Nᵢ(t+1) = N(t) +  σᵢ(t), where σᵢ(t) ∼ Normal(σᵢ)
    end
    export NeutralParameters

    NeutralParameters(;
        σ = collect(Parameter(0.3) for i in 1:50)
    ) = NeutralParameters(σ)

    struct Neutral <: DynamicsModel
        parameters::NeutralParameters
    end
    
    Neutral(; parameters = NeutralParameters()) = Neutral(parameters)


    function (model::Neutral)(state::Vector) 
        for s in state
            # extinciton is an absorbing boundary condition 
            if s > 0
                s = s + rand(Normal(model.σ[p]))
            else 
                s = 0
            end
        end 
    end

    export Neutral

end
