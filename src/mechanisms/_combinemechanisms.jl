Base.:+(a::T, b::V) where {T<:Rule,V<:Rule} = Ruleset(a, b)
Base.:+(a::T, b::V) where {T<:Ruleset,V<:Rule} = Ruleset(rules(a)..., b)
Base.:+(a::T, b::V) where {T<:Rule,V<:Ruleset} = Ruleset(a, rules(b)...)
Base.:+(a::T, b::V) where {T<:Ruleset,V<:Ruleset} = Ruleset(rules(a)..., rules(b)...)
