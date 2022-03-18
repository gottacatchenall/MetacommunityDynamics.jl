abstract type FunctionalResponse end

struct HollingTypeI{AT} <: FunctionalResponse
    A::AT
    HollingTypeI(a::A) where {A} = new{A}(a)
end
(fr::HollingTypeI)(c::T, r::T) where {T<:Biomass} = @fastmath fr.A * r

# aliases
LinearFunctionalResponse(a) = HollingTypeI(a)
LotkaVolterra(a) = HollingTypeI(a)

struct HollingTypeII{AT,HT} <: FunctionalResponse
    a::AT  ## attack rate
    h::HT ## handling time
    HollingTypeII(a::A, h::H) where {A,H} = new{A,H}(a, h)
end
(afr::HollingTypeII)(c, r) = @fastmath (afr.a * r) / (afr.a * afr.h * r + 1)
# aliases
MichaelisMenten(a, h) = HollingTypeII(a, h)

struct HollingTypeIII{AT,HT,BT} <: FunctionalResponse
    a::AT  ## attack rate
    h::HT ## handling time
    β::BT ## scaling 
    HollingTypeIII(a::A, h::H, β::B) where {A,H,B} = new{A,H,B}(a, h, β)
end
(afr::HollingTypeIII)(c, r) = @fastmath (afr.a * r) / ((afr.a * afr.h * r)^β + 1)


struct CrowleyMartin{WT,UT,VT} <: FunctionalResponse
    w::WT
    u::UT
    v::VT
    CrowleyMartin(w::W, u::U, v::V) where {W,U,V} = new{W,U,V}(w, u, v)
end
(cmfr::CrowleyMartin)(c, r) =
    @fastmath (cmfr.w * c * r) / (1 + c * cmfr.u + r * cmfr.v + c * r * cmfr.u * cmfr.v)


struct Eating{R,W,FR,D} <: CellRule{R,W}
    functionalresponse::FR
    dt::D
end

Eating{R,W}(; functionalresponse::F = LotkaVolterra(1.5), dt::D = 0.1) where {R,W,F,D} =
    Eating{R,W}(functionalresponse, dt)

function DynamicGrids.applyrule(data, rule::Eating, (C, R), index)
    C > zero(C) || return zero(C), R
    R > zero(R) || return C, zero(R)

    fr = rule.functionalresponse(C, R)
    C += C * fr * rule.dt
    R -= C * fr * rule.dt

    # TODO
    # in the case this causes R to go extinct,
    # this should only grow C as much as the remaining value of R

    C > zero(C) || return zero(C), R
    R > zero(R) || return C, zero(R)
    return C, R
end


"""
    Shortcut to make many C->R layers. Instead of having all of the eating between pairs
    of species in a single rule, builds a ruleset where each rule is a single consumer-resource interaction. 
"""
function FoodWebEating(
    species::DiscreteSpeciesPool,
    fr::FunctionalResponse;
    dt = 0.1,
)

    """

        TODO: this needs to interate over all pairs of Cs,Rs, but use
        a different index to determine if that interation between i,j occurs
        in the metaweb. 

    """
            
    mw = metaweb(species)
    spnames = species.species
    numspecies = length(spnames)
    allrules = Ruleset()
    for i = 1:numspecies, j = 1:numspecies
        if mw[i,j] == 1 
            Csym, Rsym = spnames[j], spnames[i]         
            thisrule = Eating{Tuple{Csym,Rsym}}(functionalresponse = fr, dt = dt)
            allrules = Ruleset(rules(allrules)..., thisrule)
        end
    end

    return allrules
end
