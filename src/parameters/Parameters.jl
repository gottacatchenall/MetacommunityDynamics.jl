
# Parameter is an abstract type for DynamicsModels, Landscapes and Landscpae Generators, Metaweb generators, and so on.

# We want parameters to be able to be correlated across Locations in Landscapes or across time in the DynamicsModels.

module Parameters
    abstract type Parameter end

    export Parameter
end