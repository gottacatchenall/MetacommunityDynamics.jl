 module MCDSimulation
    using ..Dynamics

    function ∫xₜdt(model::DynamicsModel)
        x₀ = model.trajectory[1]
        ẋ = model.dynamics_model
        @show x₀
        accumulate( (current, _) -> ẋ(current), model.trajectory; init=x₀ )

    end

    function simulate(model::DynamicsModel; initial_condition=0)

#        ∫xₜdt(model)

        model.has_been_run = true
    end

    export simulate

end
