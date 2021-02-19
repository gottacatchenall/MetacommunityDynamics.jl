module Metawebs

    using EcologicalNetworks: nichemodel

    struct Metaweb
        adjacencyMatrix::Array{Number,2}
    end
    Metaweb(; numberOfSpecies::Int = 10, connectance::Float64 = 0.15) = Metaweb(Array(nichemodel(numberOfSpecies, connectance).A))
    Base.size(m::Metaweb) = size(m.A)[1]


    export Metaweb

end
