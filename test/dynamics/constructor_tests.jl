module DynamicsConstructorTests
    using Test
    using MetacommunityDynamics
    using MetacommunityDynamics.Dynamics
    using MetacommunityDynamics.NeutralModel



    model = Neutral()
    @test typeof(model) <: DynamicsModel

    instance = DynamicsInstance()
    @test typeof(instance) <: DynamicsInstance

    @show instance

end
