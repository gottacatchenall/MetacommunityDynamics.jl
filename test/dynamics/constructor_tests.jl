module DynamicsConstructorTests
    using Test
    using MetacommunityDynamics
    using MetacommunityDynamics.Dynamics
    using MetacommunityDynamics.Dynamics.AbundanceNeutral



    model = AbundanceNeutralModel()
    @test typeof(model) <: DynamicsModel

    trajectory = model()
    @test typeof(trajectory) == MetacommunityTrajectory

    

end
