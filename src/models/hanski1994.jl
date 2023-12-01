struct Hanski1994 
    c::Parameter 
    e::Parameter
    x::Parameter  
    dk::DispersalKernel
end



# Eᵢ = e / (Aᵢ)ˣ  , if Aᵢ > e^(1/x), else 0

# Cᵢ = (Mᵢ)^2 / (Mᵢ^2 + γ^2)