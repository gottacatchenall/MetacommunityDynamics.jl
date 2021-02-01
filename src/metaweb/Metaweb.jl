module Metawebs

    using EcologicalNetworks: nichemodel

    struct Metaweb
        edgelist::Array{Number,2}
    end
    Metaweb(; numSpecies::Int = 30, connectance::Float64 = 0.1) = Metaweb(Array(nichemodel(numSpecies, connectance).edges))
    Base.size(m::Metaweb) = size(m.edgelist)[1]


    export Metaweb

end
