abstract type FunctionalResponse end

struct HollingTypeI{AT} <: FunctionalResponse
    A::AT 
    HollingTypeI(a::A) where {A} = new{A}(a) 
end 
(fr::HollingTypeI)(c::T,r::T) where {T <: Biomass} = @fastmath fr.A*r

# aliases
LinearFunctionalResponse(a) = HollingTypeI(a)
LotkaVolterra(a) = HollingTypeI(a)

struct HollingTypeII{AT,HT} <: FunctionalResponse
    a::AT  ## attack rate
    h::HT ## handling time
    HollingTypeII(a::A,h::H) where {A,H} = new{A,H}(a,h) 
end 
(afr::HollingTypeII)(c,r) = @fastmath (afr.a*r)/(afr.a*afr.h*r + 1)
# aliases
MichaelisMenten(a,h) = HollingTypeII(a,h)

struct HollingTypeIII{AT,HT,BT} <: FunctionalResponse
    a::AT  ## attack rate
    h::HT ## handling time
    β::BT ## scaling 
    HollingTypeIII(a::A, h::H, β::B) where {A,H,B} = new{A,H,B}(a,h,β) 
end 
(afr::HollingTypeIII)(c,r) = @fastmath (afr.a*r)/((afr.a*afr.h*r)^β + 1)


struct CrowleyMartin{WT,UT,VT} <: FunctionalResponse
    w::WT 
    u::UT
    v::VT
    CrowleyMartin(w::W, u::U, v::V) where {W,U,V} = new{W,U,V}(w,u,v) 
end 
(cmfr::CrowleyMartin)(c,r) = @fastmath (cmfr.w*c*r)/(1+c*cmfr.u + r*cmfr.v + c*r*cmfr.u*cmfr.v)


struct Eating{R,W,FR,D} <: CellRule{R,W}
    functionalresponse::FR
    dt::D
end

Eating{R,W}(;functionalresponse::F=LotkaVolterra(1.5), dt::D=0.1) where {R,W,F,D} = Eating{R,W}(functionalresponse, dt)

function DynamicGrids.applyrule(data, rule::Eating, (C,R), index) 
    C > zero(C)  || return zero(C),R
    R > zero(R)  || return C,zero(R)

    fr = rule.functionalresponse(C,R)
    C += C*fr*rule.dt
    R -= C*fr*rule.dt

    C > zero(C) || return zero(C),R 
    R > zero(R) || return C,zero(R)
    return C,R
end


