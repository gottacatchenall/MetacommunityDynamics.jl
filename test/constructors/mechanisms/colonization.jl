module ColonizationTests
    using MetacommunityDynamics
    using Test


    # ------------------------------------------------------------------------------------
    #
    # RandomColonization constructors 
    #
    # ------------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------------
    # RandomColonization constructor with no arguments
    # ------------------------------------------------------------------------------------
    rc_no_kw = RandomColonization()
    @test typeof(rc_no_kw) <: Colonization

    # ------------------------------------------------------------------------------------
    # RandomColonization constructor with keyword arguments
    # ------------------------------------------------------------------------------------
    v = rand()
    rc_kw = RandomColonization(probability=v)
    @test typeof(rc_kw) <: Colonization
    @test rc_kw.probability == v


    # ------------------------------------------------------------------------------------
    #
    # LevinsColonization constructors 
    #
    # ------------------------------------------------------------------------------------ 
    
    # ------------------------------------------------------------------------------------
    # LevinsColonization constructor with no arguments
    # ------------------------------------------------------------------------------------
    rc_kw = LevinsColonization()
    @test typeof(rc_kw) <: Colonization

    # ------------------------------------------------------------------------------------
    # LevinsColonization constructor with no arguments
    # ------------------------------------------------------------------------------------
    v = rand()
    lc_kw = LevinsColonization(probability=v)
    @test typeof(lc_kw) <: Colonization
    @test lc_kw.probability == v


    # ------------------------------------------------------------------------------------
    #
    # SpatiallyExplicitLevinsColonization constructors 
    #
    # ------------------------------------------------------------------------------------ 
    


end