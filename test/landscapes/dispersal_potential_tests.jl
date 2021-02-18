module DispersalPotentialTests
    using Test
    using MetacommunityDynamics.MCDParams
    using MetacommunityDynamics.Landscapes
    using MetacommunityDynamics.Dynamics.Dispersal


    #=
        4. Creating Dispersal Potential from Location Set with default params
    =#
    # 4.1 default
    potential = DispersalPotential()

    # 4.2 predefined locations
    loc = LocationSet()
    potential = DispersalPotential(locations=loc)

    # 4.2 IBDandCutoff default parameters
        generator= Dispersal.DispersalPotentialGenerators.IBDandCutoff()

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
        generator0= Dispersal.DispersalPotentialGenerators.IBDandCutoff(alpha=Parameter(0.0))
        generator3= Dispersal.DispersalPotentialGenerators.IBDandCutoff(alpha=Parameter(3.0))
        alpha0 = generator0(locations=loc)
        alpha3 = generator3(locations=loc)
        @test alpha0.matrix != alpha3.matrix


    # 4.3 IBDandCutoff specific parameters
    generator = Dispersal.DispersalPotentialGenerators.IBDandCutoff(alpha=Parameter(3))

    potential1 = generator()
    # 4.3.1 potential adds up to 1 (or at least 0.999999...)
    for i in 1:length(potential1)
        @test sum(potential[i,:]) ≈ 1
    end

end
