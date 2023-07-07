
@kwdef struct DispersalKernel
    func::Function = (x, decay) -> exp(-x * decay) # a function mapping (x, decay) to a value in [0,1]
    decay = 3.0 # a positive real number 
    max_distance = 1.0 # cutoff threshold for a value of func to be considered 0
end

max_distance(dk::DispersalKernel) = dk.max_distance
decay(dk::DispersalKernel) = dk.decay

function (dk::DispersalKernel)(x)
    x > max_distance(dk) ? 0 : dk.func(x, decay(dk))
end

Base.string(kern::DispersalKernel) = """
{bold}Decay: {/bold}{yellow}$(kern.decay){/yellow}
{bold}Maximum Dispersal Distance: {/bold}{#a686eb}$(kern.max_distance){/#a686eb}
"""
Base.show(io::IO, ::MIME"text/plain", kern::DispersalKernel) = print(
    io,
    string(
        Panel(
            string(kern);
            title = string(typeof(kern)),
            style = "#a686eb  dim",
            title_style = "default #a686eb bold",
            width = 35,
            padding = (2, 2, 1, 1),
        ),
    ),
)

function kernel_matrix(space, kernel)
    distmat = distance_matrix(space)
    broadcast(x -> x == 0 ? 0 : kernel(x), distmat)
end


dk = DispersalKernel()