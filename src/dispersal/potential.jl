"""
    DispersalPotential

A dispersal potential is a matrix that contains the pairwise 
probability of dispersal between sites in an `AbstractSpace`.

Note this is a doubly-stochastic matrix, meaning all rows 
and columns sum to 0.  

"""
struct DispersalPotential{T}
    matrix::Matrix{T}
end

function DispersalPotential(kernel::DispersalKernel, sg::SpatialGraph) 
    ns = numsites(sg)
    kernmat = kernel_matrix(sg, kernel)
    mat = zeros(Float32, size(kernmat))

    for i = 1:ns, j = 1:ns
        if (sum(kernmat[i, :]) > 0)
            mat[i, j] = kernmat[i, j] / sum(kernmat[i, :])
        end
    end
    DispersalPotential(mat)
end

Base.getindex(potential::DispersalPotential, i::T, j::T) where {T<:Integer} =
    potential.matrix[i, j]

_possible_links(mat) = prod(size(mat)) - size(mat,1)


Base.string(potential::DispersalPotential) = """
{bold}{#87d6c1}DispersalPotential{/#87d6c1}{/bold} with {blue}$(length(findall(!iszero,
potential.matrix))){/blue} out of $(_possible_links(potential.matrix)) possible links.
"""
Base.show(io::IO, ::MIME"text/plain", potential::DispersalPotential) = begin 
    tprint(string(potential))
    print(
        io,
        heatmap(potential.matrix, xlabel="Node i", ylabel="Node j", zlabel="ϕᵢⱼ", width=30)
    )
end
