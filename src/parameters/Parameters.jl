
# Parameter is an abstract type for DynamicsModels, Landscapes and Landscpae Generators, Metaweb generators, and so on.

# We want parameters to be able to be correlated across Locations in Landscapes or across time in the DynamicsModels.

module Parameters
    using Distributions

    struct Parameter{T <: Distribution}
    end

    draw(param::Parameter) = rand(param)


    export Parameter
end
