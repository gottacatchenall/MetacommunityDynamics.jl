struct LevinsMetapopulation <: Model{Metapopulation,Occupancy,Spatial,Discrete}
    sg::SpatialGraph
    c::Parameter
    e::Parameter
end 

initial(lev::LevinsMetapopulation) = [rand(Bernoulli(0.5)) for i in 1:numsites(lev.sg)]
numspecies(::LevinsMetapopulation) = 1

function ∂u(lm::LevinsMetapopulation, u, θ) 
    c,e = θ
    for i in eachindex(u)
        u[i] = u[i] == true ? !(rand() < e[i]) : rand() < c[i]
    end
    return u
end


function LevinsMetapopulation(;
    c = 0.3,
    e = 0.1,
    sg = SpatialGraph()
)
    LevinsMetapopulation(
        sg,
        Parameter([c for i in 1:numsites(sg)]),
        Parameter([e for i in 1:numsites(sg)])
    )
end

