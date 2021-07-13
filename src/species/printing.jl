Base.show(io::IO, sp::DiscreteUnipartiteSpeciesPool) = begin
    stack = CrayonStack()
    Base.print(io, stack, "discrete species pool with ")
    Base.print(io, push!(stack, crayon"green"), numspecies(sp))
    Base.print(io, pop!(stack), " species and ")
    Base.print(io, push!(stack, crayon"blue"), 1)
    Base.print(io, pop!(stack), " partition")
end


Base.show(io::IO, sp::DiscreteKpartiteSpeciesPool) = begin
    stack = CrayonStack()

    Base.print(io, stack, "discrete species pool with ")
    Base.print(io, push!(stack, crayon"green"), numspecies(sp))
    Base.print(io, pop!(stack), " species across ")
    Base.print(io, push!(stack, crayon"blue"), sp.partitions)
    Base.print(io, pop!(stack), " partitions")
end
