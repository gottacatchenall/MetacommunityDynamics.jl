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
    using .Landscape

    # ===========================================
    # metaweb
    # ===========================================
    include(joinpath(".", "metaweb/Metaweb.jl"))
    using .Metaweb


    # ===========================================
    # dynamics
    # ===========================================
    include(joinpath(".", "dynamics/Dynamics.jl"))
    using .Dynamics


    # ===========================================
    # summary stats
    # ===========================================
    include(joinpath(".", "summary/SummaryStats.jl"))
    using .SummaryStats



end
