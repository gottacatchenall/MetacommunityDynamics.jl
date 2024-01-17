_deparameterize(::M) where {M<:Model} = M.name.wrapper

function spatialize(model::M, sg::SpatialGraph, sp::SpeciesPool; niche=nothing) where {SC,N,D,SP<:Spatialness,M<:Model{SC,N,SP,D}}
    p = _spatial_parameters(model, sg, sp, niche)

    # TODO this may need to handle models with additional parametric types
    # We do this by assuming all custom parametric types are before the
    # Local/Spatial one. 

    _deparameterize(model){M.parameters[1:end-1]...,Spatial}(Parameter.(values(p))...)
end 

function _spatial_parameters(model::M, sg, sp, niche) where {M<:Model}
    paramnames = fieldnames(M)
    tr = sp.traits
    ns = numsites(sg)
    θs = []
    for i in 1:ns
        local_env = environment(sg, i)
        θ_local = !isnothing(niche) ? niche(model, tr, local_env) : paramdict(model)
        push!(θs, θ_local)
    end
    NamedTuple([p=>[θ[p] for θ in θs] for p in paramnames])
end 
