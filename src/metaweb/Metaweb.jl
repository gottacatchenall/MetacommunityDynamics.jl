module Metawebs

    using EcologicalNetworks: nichemodel

    struct Metaweb
        edgelist::Array{Number,2}
    end
    Metaweb(; numberOfSpecies::Int = 10, connectance::Float64 = 0.15) = Metaweb(Array(nichemodel(numberOfSpecies, connectance).edges))
    Base.size(m::Metaweb) = size(m.edgelist)[1]


    export Metaweb

end
