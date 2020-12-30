module DispersalPotentialGenerators
    using ..Dispersal
    using ..Dispersal.DispersalKernels
    using ..Landscapes
    using ..MetacommunityDynamics.MCDParams


    """
        IBDandCutoff <: DispersalPotentialGenerator type definition

        The resulting dispersal potential
    """
    struct IBDandCutoff{T <: DispersalKernel} <: DispersalPotentialGenerator
        alpha::Parameter
        epsilon::Parameter
        kernel::T
    end
    IBDandCutoff(; alpha=Parameter(3.0), epsilon=Parameter(0.1), kernel=ExpKernel()) = IBDandCutoff(alpha, epsilon, kernel)
    export IBDandCutoff

    function (generator::IBDandCutoff)(;
        locations::LocationSet = LocationSet(),
    )
        alpha = draw(generator.alpha)
        epsilon = draw(generator.epsilon)
        kernel = generator.kernel

        num_locations = size(locations)
        matrix::Array{Float64,2} = zeros(num_locations, num_locations)

        for i = 1:num_locations
            row_sum = 0.0
            for j = 1:num_locations
                if (i != j)
                    kernel_val = kernel(alpha, distance(locations[i], locations[j]))

                    if (kernel_val > epsilon)
                        matrix[i,j] = kernel_val
                        row_sum += kernel_val
                    end
                end
            end
        # Normalize
            if (row_sum > 0.0)
                for j = 1:num_locations
                    matrix[i,j] = matrix[i,j] / row_sum
                end
            else
                # if node i happens to not have any edges
                matrix[i,i] = 1.0
            end
        end
        return DispersalPotential(matrix)
    end


    function draw_from_dispersal_potential_row(dispersal_potential::Dispersal.DispersalPotential, row::Int64)
        return rand(Distributions.Categorical(dispersal_potential.matrix[row,:]))
    end
end
