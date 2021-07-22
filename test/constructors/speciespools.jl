module SpeciesPoolTests
    using MetacommunityDynamics
    using EcologicalNetworks: nichemodel
    using Test

    # ------------------------------------------------------------------------------------
    #
    # DiscreteUnipartiteSpeciesPool constructors 
    #
    # ------------------------------------------------------------------------------------

    
    # ------------------------------------------------------------------------------------
    # DiscreteUnipartiteSpeciesPool constructor with keyword arguments
    # ------------------------------------------------------------------------------------
    @test typeof(DiscreteUnipartiteSpeciesPool()) <: DiscreteUnipartiteSpeciesPool

    # ------------------------------------------------------------------------------------
    # DiscreteUnipartiteSpeciesPool constructor with keyword arguments
    # ------------------------------------------------------------------------------------
    kwtest_pool = DiscreteUnipartiteSpeciesPool(numspecies = 23)
    @test typeof(kwtest_pool) <: DiscreteUnipartiteSpeciesPool
    @test length(species(kwtest_pool)) == 23

    # ------------------------------------------------------------------------------------
    # DiscreteUnipartiteSpeciesPool constructor with UnipartiteEcologicalNetwork as input
    # ------------------------------------------------------------------------------------
    network = nichemodel(30, 0.3)
    en_test_pool = DiscreteUnipartiteSpeciesPool(network)
    @test typeof(en_test_pool) <: DiscreteUnipartiteSpeciesPool


    # ------------------------------------------------------------------------------------
    # DiscreteUnipartiteSpeciesPool constructor with a vector of strings as input
    # ------------------------------------------------------------------------------------
    fakespecieslist = ["species one", "species two", "species three"]
    FS_SP = DiscreteUnipartiteSpeciesPool(fakespecieslist)
    @test typeof(FS_SP) <: DiscreteUnipartiteSpeciesPool
    @assert species(FS_SP) == Symbol.(fakespecieslist)

    # ------------------------------------------------------------------------------------
    # DiscreteUnipartiteSpeciesPool constructor from vector of symbols 
    # ------------------------------------------------------------------------------------
    symbolslist = Symbol.(fakespecieslist)
    @test typeof(DiscreteUnipartiteSpeciesPool(symbolslist)) <: DiscreteUnipartiteSpeciesPool
    @test species(FS_SP) == symbolslist

    # ------------------------------------------------------------------------------------
    # DiscreteUnipartiteSpeciesPool constructor with vector of symbols and 
    # a matrix as input
    # ------------------------------------------------------------------------------------
    fakeadjmatrix = broadcast(x -> rand() < 0.5, zeros(Int32, 50,50))
    fakeadj_test = DiscreteUnipartiteSpeciesPool(symbolslist, fakeadjmatrix)
    @test typeof(fakeadj_test)<: DiscreteUnipartiteSpeciesPool
    @test metaweb(fakeadj_test) == fakeadjmatrix
    @test species(fakeadj_test) == symbolslist


    # ------------------------------------------------------------------------------------
    # DiscreteUnipartiteSpeciesPool constructor with vector of strings and 
    # a matrix as input
    # ------------------------------------------------------------------------------------
    fakeadj_strings_test= DiscreteUnipartiteSpeciesPool(fakespecieslist, fakeadjmatrix)
    @test typeof(fakeadj_strings_test)<: DiscreteUnipartiteSpeciesPool
    @test metaweb(fakeadj_strings_test) == fakeadjmatrix
    @test species(fakeadj_strings_test) == symbolslist



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