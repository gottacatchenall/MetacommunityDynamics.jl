
abstract type InteractionType end 

abstract type Competition <: InteractionType end 
abstract type Trophic <: InteractionType end 

struct Interactions{T<:InteractionType}

end