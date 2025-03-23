struct SpatialGraph{C<:Coordinates,T<:Real,P<:Union{Matrix{T},Vector{Matrix{T}}},K<:DispersalKernel}
    coordinates::C
    kernel::K
    potential::P
end

multispecies(::SpatialGraph{C,P}) where {C,P} = P <: Vector ? true : false 
kernel(sg::SpatialGraph) = sg.kernel 
coordinates(sg::SpatialGraph) = sg.coordinates
numsites(sg::SpatialGraph) = numsites(coordinates(sg))
envdims(sg::SpatialGraph) = envdims(coordinates(sg))

environment(sg::SpatialGraph) = environment(coordinates(sg))
environment(sg::SpatialGraph, i) = environment(coordinates(sg), i)


SpatialGraph(coords::Coordinates, kernel::DispersalKernel) = SpatialGraph(coords, kernel, dispersal_potential(kernel, coords))
SpatialGraph(kernel::DispersalKernel, coords::Coordinates) = SpatialGraph(coords, kernel, dispersal_potential(kernel, coords))

SpatialGraph(coords::Coordinates; kernel = DispersalKernel()) = SpatialGraph(coords, kernel, dispersal_potential(kernel, coords))
SpatialGraph(kernel::DispersalKernel; coordinates = Coordinates(25)) = SpatialGraph(coordinates, kernel, dispersal_potential(kernel, coordinates))
SpatialGraph(; coordinates = Coordinates(25), kernel = DispersalKernel()) = SpatialGraph(coordinates, kernel, dispersal_potential(kernel, coordinates))

function dispersal_potential(kernel::DispersalKernel, coords::Coordinates{T,P}) where {T,P} 
    ns = numsites(coords)
    kernmat = kernel_matrix(coords, kernel)
    mat = zeros(T, size(kernmat))
    for (i,r) in enumerate(eachrow(kernmat))
        s = sum(r)
        if (s > 0)
            for j in 1:ns
                mat[i, j] = kernmat[i, j] / s
            end
        end
    end
    return mat
end

_possible_links(mat) = prod(size(mat)) - size(mat,1)



# ====================================================
#
#   Plotting
#
# =====================================================

Base.string(sg::SpatialGraph) = """
{bold}{#87d6c1}SpatialGraph{/#87d6c1}{/bold} with {blue}$(length(findall(!iszero,
sg.potential))){/blue} out of $(_possible_links(sg.potential)) possible links.
"""
Base.show(io::IO, ::MIME"text/plain", sg::SpatialGraph) = begin 
    tprint(string(sg))
    #print(
    #    io,
    plt = UnicodePlots.heatmap(sg.potential, xlabel="Node i", ylabel="Node j", zlabel="ϕᵢⱼ", width=30)
    display(plt)
    #)
end


# ====================================================
#
#   Tests
#
# =====================================================

@testitem "We can create a spatial graph" begin
    sg = SpatialGraph()
    @test typeof(sg) <: SpatialGraph
end

@testitem "We can create a spatial graph with custom coordinates as positional argument" begin
    coords = Coordinates(10)
    sg = SpatialGraph(coords)
    @test typeof(sg) <: SpatialGraph
    @test numsites(sg) == 10
end


@testitem "We can create a spatial graph with custom kernel as positional argument" begin
    kern = DispersalKernel(max_distance=0.25)
    sg = SpatialGraph(kern)
    @test typeof(sg) <: SpatialGraph
    @test max_distance(kernel(sg)) == 0.25
end

@testitem "We can create a spatial graph with custom kernel and coordinates as positional arguments both ways" begin
    kern = DispersalKernel(max_distance=0.25)
    coords = Coordinates(10)

    sg = SpatialGraph(kern, coords)
    @test typeof(sg) <: SpatialGraph
    @test max_distance(kernel(sg)) == 0.25
    @test numsites(sg) == 10

    sg = SpatialGraph(coords, kern)
    @test typeof(sg) <: SpatialGraph
    @test max_distance(kernel(sg)) == 0.25
    @test numsites(sg) == 10

end

@testitem "We can create a spatial graph with custom coordinates as keyword argument" begin
    coords = Coordinates(10)
    sg = SpatialGraph(;coordinates = coords)
    @test typeof(sg) <: SpatialGraph
    @test numsites(sg) == 10
end

@testitem "We can create a spatial graph with custom kernel as keyword argument" begin
    kern = DispersalKernel(max_distance=0.25)
    sg = SpatialGraph(;kernel=kern)
    @test typeof(sg) <: SpatialGraph
    @test max_distance(kernel(sg)) == 0.25
end

@testitem "We can create a spatial graph with both custom kernel and coordinates as keyword argument" begin
    kern = DispersalKernel(max_distance=0.25)
    coords = Coordinates(10)
    sg = SpatialGraph(;kernel=kern, coordinates=coords)
    @test typeof(sg) <: SpatialGraph
    @test max_distance(kernel(sg)) == 0.25
    @test numsites(sg) == 10
end

