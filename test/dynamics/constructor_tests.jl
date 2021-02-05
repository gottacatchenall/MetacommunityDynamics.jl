module DynamicsConstructorTests
    using Test
    using Distributions
    using MetacommunityDynamics
    using MetacommunityDynamics.MCDParams
    using MetacommunityDynamics.Dynamics
    using MetacommunityDynamics.Dynamics.AbundanceNeutral

    model = AbundanceNeutralModel(
            metaweb = Metaweb(numberOfSpecies=30),
            parameters=AbundanceNeutralParameters(σ = Parameter(Normal(0, 0.01)))
    )
    trajectory = model()

    @test typeof(model) <: DynamicsModel
    @test typeof(trajectory) == MetacommunityTrajectory{Float64}

end
