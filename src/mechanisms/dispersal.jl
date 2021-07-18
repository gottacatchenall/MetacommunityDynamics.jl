"""
    AdjacentBernoulliDispersal

    The realized amount of biomass i -> j is drawn
    from a `Distrubtion` D.

    The expected value of the distribution is set to be 
    E[D] = B_i * k_{ij}

"""
struct AdjacentBernoulliDispersal{R,W,N<:AbstractKernelNeighborhood,P<:Float64} <: SetNeighborhoodRule{R,W}
    neighborhood::N 
    probability::P # probability of dispersal
end
function AdjacentBernoulliDispersal{R,W}(; kw...) where {R,W}
    AdjacentBernoulliDispersal{R,W}(AdjacentBernoulliDispersal(; kw...))
end

function DynamicGrids.applyrule!(data, rule::AdjacentBernoulliDispersal{R,W}, N, I) where {R,W}
    N == zero(N) && return nothing
    
    if rand() < rule.probability
        sum = zero(N)
        for (offset, k) in zip(offsets(rule), kernel(rule))
            @inbounds propagules = N * k
            @inbounds add!(data[W], propagules, I .+ offset...)
            sum += propagules
        end
        @inbounds sub!(data[W], sum, I...)
    end
end

function AdjacentBernoulliDispersal(consumernames::Vector{Symbol}, dk::DispersalKernel, prob::Float32) 
    allrules = Ruleset()
    for c in consumernames 
        allrules += AdjacentBernoulliDispersal{c}(dk, prob)
    end
    return allrules
end



"""
    AdjacentTruncatedNormalDispersal

    The expected value of the distribution is set to be 
    E[D] = B_i * k_{ij}

"""
struct AdjacentTruncatedNormalDispersal{R,W,N<:AbstractKernelNeighborhood,P<:Float64} <: SetNeighborhoodRule{R,W}
    neighborhood::N 
    probability::P # unit probability of dispersal
end
function AdjacentTruncatedNormalDispersal{R,W}(; kw...) where {R,W}
    AdjacentTruncatedNormalDispersal{R,W}(AdjacentTruncatedNormalDispersal(; kw...))
end


"""
    AdjacentPoissonDispersal

    The expected value of the distribution is set to be 
    E[D] = B_i * k_{ij}.

    Only returns integers. Do we care? not really

"""
struct AdjacentPoissonDispersal{R,W,N<:AbstractKernelNeighborhood,P<:Float64} <: SetNeighborhoodRule{R,W}
    neighborhood::N 
    probability::P # unit probability of dispersal
end
function AdjacentPoissonDispersal{R,W}(; kw...) where {R,W}
    AdjacentPoissonDispersal{R,W}(AdjacentPoissonDispersal(; kw...))
end