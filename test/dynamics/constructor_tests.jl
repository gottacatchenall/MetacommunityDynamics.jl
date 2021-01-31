module DynamicsConstructorTests
    using Test
    using MetacommunityDynamics
    using MetacommunityDynamics.Dynamics
    using MetacommunityDynamics.NeutralModel



    model = Neutral()
    @test typeof(model) <: DynamicsModel

    instance = DynamicsInstance()
    @test typeof(instance) <: DynamicsInstance

    @test instance.has_been_run == false
    simulate(instance)

    @test instance.has_been_run == true

end
