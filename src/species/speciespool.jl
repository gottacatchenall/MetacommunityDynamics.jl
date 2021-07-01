struct SingleSpecies <: DiscreteSpeciesPool 
    species::Vector{Symbol}
end

struct DiscreteUnipartiteSpeciesPool <: DiscreteSpeciesPool 
    species::Vector{Symbol}
    metaweb::Matrix
end 

struct DiscreteKpartiteSpeciesPool <: DiscreteSpeciesPool 
    species::Vector{Symbol}
    metaweb::Matrix
    partitions::Int
end 

struct ContinuousUnipartiteSpeciesPool <: ContinuousSpeciesPool 
    traitdists
end 

struct ContinuousKpartiteSpeciesPool <: ContinuousSpeciesPool 
    traitdists
    partitions::Int
end 

species(sp::T) where {T <: DiscreteSpeciesPool} = sp.species


# some interfaces to EN generators 

function layers(speciespool::ST; element=Biomass, dims=(100,100)) where {ST <: DiscreteSpeciesPool}
    specieslist = species(speciespool)
    layerlist = []
    for sp in specieslist
        thislayer = zeros(element, dims...)
        push!(layerlist, thislayer)
    end
    return layerlist
end
layers(speciespool::SPT, element::ET; dims=(100,100)) where {SPT <: DiscreteSpeciesPool, ET <: Measurement} = layers(speciespool, element=element, dims=dims)


function speciespool(net::UnipartiteNetwork)
    DiscreteUnipartiteSpeciesPool([Symbol(i) for i in net.S], Matrix(net.edges))
end


net = EcologicalNetworks.nichemodel(10, 0.3)

Matrix(net.edges)

sp = speciespool(net)

layers = specieslayers(sp)





