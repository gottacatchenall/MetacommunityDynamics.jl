module LandscapeGenerationTests
    using Test
    using MetacommunityDynamics.MCDParams
    using MetacommunityDynamics.Landscapes
    #=
    1.    Test Location constructors
    =#
    @test typeof(Location()) == Location # test default constructor
    @test ndims(Location()) == 2   # test default dimensionality
    @test ndims(Location(dimensions=5)) == 5 # test changing dims

    #=
    2.    Test LocationSet default constructor
    =#
        locs = LocationSet()
        #2.1
            @test typeof(locs) == LocationSet
        # 2.2
            @test length(locs) == 5
        # 2.3
            @test size(locs) == 5

        for l in locs
            # 2.4
                @test ndims(l) == 2
        end

    #=
        3.    Test LocationSet constructor with options
    =#
        locs = LocationSet(numberOfLocations=30, dimensions=7)
            # 3.1
                @test typeof(LocationSet()) == LocationSet # test default constructor

            # 3.2
                @test length(locs) == 30
            # 3.3
                @test size(locs) == 30
        for l in locs
            # 3.4
                @test ndims(l) == 7
        end




    #=
        5. Creating Dispersal Potential from Location Set with custom params
    =#


    #=
        6. DispersalPotential constructor with IBDwithCutoff
    =#

    #=
        7. DispersalPotential constructor with IBDnoCutoff
    =#

end
