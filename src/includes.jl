include("types.jl")
include("model.jl")
include("drift.jl")

include("parameters.jl")

include("environment.jl")
include("coordinates.jl")

include("species.jl")


include(joinpath("dispersal", "kernel.jl"))

include("spatialgraph.jl")
include(joinpath("dispersal", "diffusion.jl"))

include(joinpath("dispersal", "spatialize.jl"))

include("problem.jl")
include("trajectory.jl")
include("observer.jl")

include("factory.jl")

include(joinpath("models", "ricker.jl"))
include(joinpath("models", "bevertonholt.jl"))
include(joinpath("models", "logistic_model.jl"))
include(joinpath("models", "logistic_map.jl"))


include(joinpath("models", "trophiclv.jl"))
include(joinpath("models", "lvcompetition.jl"))
include(joinpath("models", "rosenzweigmacarthur.jl"))
include(joinpath("models", "levins.jl"))

include(joinpath("plots", "phase.jl"))
include(joinpath("plots", "repl.jl"))
include(joinpath("plots", "spatial.jl"))
include(joinpath("plots", "phase.jl"))
include(joinpath("plots", "vectorfield.jl"))
