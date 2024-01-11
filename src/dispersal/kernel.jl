
struct DispersalKernel{T<:Number}
    func::Function # a function mapping (x, decay) to a value in [0,1]
    decay::T # a positive real number 
    max_distance::T # cutoff threshold for a value of func to be considered 0
end

function DispersalKernel(; func = (x,decay) -> exp(-x*decay), decay::T = 3.0, max_distance::V = 1.0) where {T,V}
    decay < 0 && throw(ArgumentError, "Decay must be greater than or equal to zero.")
    max_distance <= 0 && throw(ArgumentError("Maximum dispersal distance must be positive."))
    decay == 0 && @warn "Decay is 0. This means that dispersal is equally probable across all distances."
    DispersalKernel(func, V(decay), V(max_distance))
end 

max_distance(dk::DispersalKernel) = dk.max_distance
decay(dk::DispersalKernel) = dk.decay

function (dk::DispersalKernel)(x)
    x > max_distance(dk) ? 0 : dk.func(x, decay(dk))
end

Base.string(kern::DispersalKernel) = """
{yellow}{bold}DispersalKernel{/bold}{/yellow}
"""

Base.show(io::IO, ::MIME"text/plain", kern::DispersalKernel) = begin
    tprint(io, string(kern))
    print(io, 
        replplot(kern)
    )
end

function replplot(kern::DispersalKernel)
    height,width = displaysize(stdout)  
    
    xs = LinRange(0, kern.max_distance, 99)
    ys = [kern.func.(x, kern.decay) for x in xs]
    
    ys = ys ./ sum(ys)

    xs = vcat(xs, 2xs[end]-xs[end-1])
    ys = vcat(ys, 0)


    p = lineplot(xs, ys,
        xlabel="distance", 
        ylabel="dispersal prob. density", 
        width=width-40,
    )
end

function kernel_matrix(space, kernel)
    distmat = distance_matrix(space)
    broadcast(x -> x == 0 ? 0 : kernel(x), distmat)
end


# ====================================================
#
#   Tests
#
# =====================================================

@testitem "We can create a dispersal kernel" begin
    dk = DispersalKernel()
    @test typeof(dk) <: DispersalKernel
end

@testitem "We can create a dispersal with custom maximum dispersal distance" begin
    dk = DispersalKernel(max_distance = 3.5)
    @test typeof(dk) <: DispersalKernel
    @test max_distance(dk) == 3.5

    @test_throws ArgumentError DispersalKernel(max_distance = 0.)
    @test_throws ArgumentError DispersalKernel(max_distance = -1.)
 
    @test_throws ArgumentError DispersalKernel(decay = -1.)

    @test_warn "Decay is 0. This means that dispersal is equally probable across all distances." DispersalKernel(decay=0)
end
