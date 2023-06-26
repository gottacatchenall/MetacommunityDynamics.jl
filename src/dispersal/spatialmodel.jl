function spatialize(model::Model, sg::SpatialGraph, sp::SpeciesPool, niche::Niche, diffusion::D) where D<:Union{Diffusion,Vector{Diffusion}}

    @assert numspecies(model) == numspecies(sp)
    @assert traitdims(sp) == traitdims(niche)
    @assert traitnames(sp) == traitnames(niche)

    gr = growthrate(model)
    env = environment(sg)    

    Iautotroph = findall(x-> x > 0, gr)
    adjusted_growth = zeros(numspecies(model), numsites(sg))

    # rows are params
    traits_per_species = hcat([sp.traits[tn] for tn in traitnames(sp)]...)
    for i in Iautotroph
        for j in 1:size(environment(sg), 2)
            adjusted_growth[i,j] = gr[i] * niche(traits_per_species[i,:], env[j])
        end
    end
    
    # matrix of new growth rate across species and sites.
    #   (editors note: in the long term, it would be more efficient to store
    #   this as a sparse matrix to avoid wasting memory on zeros for autotroph
    #   species. for now, species pool sizes are low enough that it doesn't matter)
    adjusted_growth

    # now inject this into new model parameters
    new_model = spatialize(model, adjusted_growth)
    SpatialModel(new_model, sg, sp, niche, diffusion)
end 