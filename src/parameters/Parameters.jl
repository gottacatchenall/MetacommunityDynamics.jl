
# Parameter is an abstract type for DynamicsModels, Landscapes and Landscpape Generators, Metaweb generators, and so on.

# We want parameters to be able to be correlated across Locations in Landscapes or across time in the DynamicsModels.

module MCDParams
    using Distributions

    struct Parameter
        distribution::Distribution
        Parameter(distribution::Distribution) = new(distribution)
        Parameter(value::Number) = new(Normal(value, 0.0))
    end
    Base.show(io::IO, p::Parameter) = print(io, "Parameter ~ ", p.distribution, "\n")

    draw(param::Parameter) = rand(param.distribution)


    export Parameter, draw
end
