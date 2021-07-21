module SpeciesPoolTests
    using MetacommunityDynamics
    using EcologicalNetworks: nichemodel
    using Test

    
    # empty constructor
    @test typeof(DiscreteUnipartiteSpeciesPool()) <: DiscreteUnipartiteSpeciesPool

    # constructor with keyword args
    kwtest_pool = DiscreteUnipartiteSpeciesPool(numspecies = 23)
    @test typeof(kwtest_pool) <: DiscreteUnipartiteSpeciesPool
    @test length(species(kwtest_pool)) == 23

    # constructor with UnipartiteEcologicalNetwork as input
    network = nichemodel(30, 0.3)
    en_test_pool = DiscreteUnipartiteSpeciesPool(network)
    @test typeof(en_test_pool) <: DiscreteUnipartiteSpeciesPool

    fakespecieslist = ["species one", "species two", "species thee"]
    FS_SP = DiscreteUnipartiteSpeciesPool(fakespecieslist)
    @test typeof(FS_SP) <: DiscreteUnipartiteSpeciesPool
    @assert species(FS_SP) == Symbol.(fakespecieslist)

    symbolslist = Symbol.(fakespecieslist)
    @test typeof(DiscreteUnipartiteSpeciesPool(symbolslist)) <: DiscreteUnipartiteSpeciesPool
    @assert species(FS_SP) == symbolslist


    fakeadjmatrix = broadcast(x -> rand() < 0.5, zeros(Int32, 50,50))
    fakeadj_test = DiscreteUnipartiteSpeciesPool(symbolslist, fakeadjmatrix)
    @test typeof(fakeadj_test)<: DiscreteUnipartiteSpeciesPool
    @test metaweb(fakeadj_test) == fakeadjmatrix
    @test species(fakeadj_test) == symbolslist

    @test typeof(DiscreteUnipartiteSpeciesPool(fakespecieslist, fakeadjmatrix)) <: DiscreteUnipartiteSpeciesPool




    """
        DiscreteKpartiteSpeciesPool
    """

    """
        ContinuousUnipartiteSpeciesPool
    """

    """
        ContinuousKpartiteSpeciesPool
    """

end