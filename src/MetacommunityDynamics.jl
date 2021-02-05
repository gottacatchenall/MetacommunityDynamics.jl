module MetacommunityDynamics
    # ===========================================
    # Dependencies
    # ===========================================
    #using EcoBase
    #using EcologicalNetworks
    #using BioEnergeticFoodWebs
    using Distributions

    # ===========================================
    # parameters
    # ===========================================
    include(joinpath(".", "parameters/Parameters.jl"))
    using .MCDParams
    export Parameter

    # ===========================================
    # landscapes
    # ===========================================
    include(joinpath(".", "landscape/Landscape.jl"))
    using .Landscapes
    export Landscape,Location, LocationSet, DispersalKernel, DispersalPotential, EnvironmentalMeasurement, EnvironmentalMeasurementSet, EnvironmentModel

    # ===========================================
    # metaweb
    # ===========================================
    include(joinpath(".", "metaweb/Metaweb.jl"))
    using .Metawebs
    export Metaweb


    # ===========================================
    # dynamics
    # ===========================================
    include(joinpath(".", "dynamics/Dynamics.jl"))
    using .Dynamics
    export DynamicsModel, DynamicsParameterSet, SimulationSettings, EnvironmentalTrajectory, MetacommunityTrajectory, AbundanceNeutralModel, Abundance, NeutralParameters, simulate, nlocations, nspecies, ntimepoints



    # ===========================================
    # summary stats
    # ===========================================
    include(joinpath(".", "summary/SummaryStats.jl"))
    using .SummaryStats


end
