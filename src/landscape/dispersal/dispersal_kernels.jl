struct GaussKernel <: DispersalKernel end 
(kern::GaussKernel)(alpha::Number, distance::Number) = exp(-1*alpha^2*distance^2)

struct ExpKernel <: DispersalKernel  end
(kern::ExpKernel)(alpha::Number, distance::Number) = exp(-1*alpha*distance)
