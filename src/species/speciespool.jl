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

numspecies(sp::T) where {T <: DiscreteSpeciesPool} = length(species(sp))
species(sp::T) where {T <: DiscreteSpeciesPool} = sp.species


# some interfaces to EN generators 
"""
    layers(speciespool::ST; element=Biomass, dims=(100,100))

    Converts a species pool to a set of layers of type `element`.
    Should be able to apply generic function. Mostly used to generate initial conditions. 
"""
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


function layernames(sp::SPT) where {SPT <: DiscreteSpeciesPool}
    return Symbol.(sp.species)
end



"""
    speciespool(net::UnipartiteNetwork)
"""
function speciespool(net::UnipartiteNetwork)
    DiscreteUnipartiteSpeciesPool([Symbol(i) for i in net.S], Matrix(net.edges))
end


"""
    bad code. to be sped up ... later....

"""
function Base.filter(f::Function, sp::T) where {T <: DiscreteSpeciesPool}

    newspecieslist = []
    indecies = []

    for (i,spec) in enumerate(species(sp))
        if f(String(spec)) == true
            push!(newspecieslist, spec)
            push!(indecies, i)
        end
    end

    newmetaweb = sp.metaweb[indecies, indecies]

    return T(newspecieslist, newmetaweb)
end



