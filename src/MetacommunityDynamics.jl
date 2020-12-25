module MetacommunityDynamics
    # ===========================================
    # Dependencies
    # ===========================================
    using EcoBase
    using EcologicalNetworks
    using BioEnergeticFoodWebs

    # ===========================================
    # landscapes
    # ===========================================
    include(joinpath(".", "dynamics/Dynamics.jl"))


    # ===========================================
    # metaweb
    # ===========================================
    include(joinpath(".", "metaweb/Metaweb.jl"))


    # ===========================================
    # dynamics
    # ===========================================
    include(joinpath(".", "dynamics/Dynamics.jl"))

    # ===========================================
    # summary stats
    # ===========================================
    include(joinpath(".", "summary/SummaryStats.jl"))



end
