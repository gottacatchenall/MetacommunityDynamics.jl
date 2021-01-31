module DynamicsConstructorTests
    using Test
    using MetacommunityDynamics
    using MetacommunityDynamics.Dynamics
    using MetacommunityDynamics.NeutralModel



    model = Neutral()
    @test typeof(model) <: DynamicsModel

    @show model

    trajectory = model()
    @test typeof(trajectory) == Trajectory
end
