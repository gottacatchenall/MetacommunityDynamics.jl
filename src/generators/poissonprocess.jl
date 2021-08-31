struct PoissonProcess end
generate(::Type{PoissonProcess}, np::Int) = rand(np, 2)

function pointstogrid(coords; gridsize = 100)
    intcoords = map(x -> Int(ceil(x * gridsize)), coords)
    z = zeros(gridsize, gridsize)
    for c in eachrow(intcoords)
        z[c...] = 1
    end
    return z
end
