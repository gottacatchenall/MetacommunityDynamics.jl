module LandscapeGenerationTests
    using Test
    using MetacommunityDynamics.MCDParams
    using MetacommunityDynamics.Landscape
    using MetacommunityDynamics.Landscape.Dispersal
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
            @test length(locs) == 20
        # 2.3
            @test size(locs) == 20

        for l in locs
            # 2.4
                @test ndims(l) == 2
        end

    #=
        3.    Test LocationSet constructor with options
    =#
        locs = LocationSet(number_of_locations=30, dimensions=7)
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
        4. Creating Dispersal Potential from Location Set with default params
    =#
        # 4.1 default
        potential = DispersalPotential()

        # 4.2 predefined locations
        loc = LocationSet()
        potential = DispersalPotential(locations=loc)

        # 4.2 IBDandCutoff default parameters
            generator=Dispersal.IBDandCutoff()

            # 4.2.1
            # Does it make a dispersal potential
            @test typeof(generator(locations=loc)) == DispersalPotential

            # 4.2.2
            # Is it consistant
            potential1 = generator(locations=loc)
            potential2 = generator(locations=loc)
            @test  potential1.matrix == potential2.matrix #TODO make equil comparison work on obj directly

            # 4.2.3
            # But not making the same thing every time
            one = generator()
            two = generator()
            @test one.matrix != two.matrix

            # 4.2.4
            # And changing parameters make different things
            generator0= Dispersal.IBDandCutoff(alpha=Parameter(0.0))
            generator3= Dispersal.IBDandCutoff(alpha=Parameter(3.0))
            alpha0 = generator0(locations=loc)
            alpha3 = generator3(locations=loc)
            @test alpha0.matrix != alpha3.matrix





        # 4.3 IBDandCutoff specific parameters
        generator =Dispersal.IBDandCutoff(alpha=Parameter(3))
        @show generator


        # 4.4 Repeatable given a fixed set of locations




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
