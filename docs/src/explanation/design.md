
# The design of `MetacommunityDynamics.jl` 

This document is for advanced users interested in contributing new models or
building complicated custom models in `MetacommunityDynamics.jl`.

## The type system

While MetacommunityDynamics enables simulation of dynamics in a single place (_locally_),
its main goal is to enable reaction-diffusion models on spatial graphs.
Similarly, although MetacommunityDynamics is perfectly adaquete for simulating the
dynamics of single-species systems, the _core design goals_ are motivated by an
interest in simulating communities on spatial graphs, where environmental
variation across each patch/node in the graph influences the dynamics at that
node/patch, with a particular emphasis on understanding how different
parameterizations of models causes regime shifts in resulting species 
compositions across space, across different levels of neutral, niche, and
dispersal proccesses.

What are the essential things you need to build a simulation model that meets
this criteria?

1. We need a way to represent different types of _models_ (e.g. Lotka-Volterra,
   Rosenzweig-MacArthur, etc). 
2. A _spatial graph_, consisting of a set of nodes/patches connected by
   dispersal, that also can represent environmental information associated with
   each patch. 
3. A _species pool_ with _traits_, which are an arbitrary set of named values
   that correspond to each species in the species pool.  
4. The _niche_, where the combination of the local (named!) environmental
   conditions at a patch and other species present shifts the parameters of the
   dynamics at that patch.
5. A model of _diffusion_. We take a dispersal kernel and normalize its value
   across each (source->target) pair of patches to create a _dispersal
   potential_, which is a distribution for each (source->target pair).


Note that all are interconnected and must interface with one another to achieve
our overall goal:
- the model's parameters must match species pool size and number of spatial
  sites  (1->2, 1->3)
- the spatial graph must provide environmental data for the niche (2 -> 4)
- the species pool must provide traits for the niche (3->4)
- the niche must provide parameters for the spatial version of the model based
  on the species pool and (spatial graph w/ environment) (2->1, 4->1)
- both the species and environment must provide named parameters to the niche (2->4,3->4)

### Models

The first element of the type system is distinguishing different properties of
different `Model`s. In EcoDynamics.jl, `Model` is the abstract type under which
all concrete model definitions are subtyped. Specifically, `Model` is defined as
a _parameteric_ abstract type where stores information about the important
meta-properties about models. 

`abstract type Model{SC<:Scale,M<:Measurement,SP<:Spatialness,D<:Discreteness} end` 

Specifically there are four different important properties which `Model` stores
(in Julia development, this design pattern is called using 'traits', although we
refrain from using that terminology in this documentation to avoid confusion
with `Trait`s as the type of information that describes properties about
species).

These four properties are `Scale`, `Measurement`, `Spatialness`, and
`Discreteness`. Each of these are defined as abstract types, and the different
values they can take on are defined as abstract types that are subtypes of the
category they correspond to.

1. `Scale` refers to the organizational scale a model is _originally_ designed,
   with the options being `Population`, `Community`, `Metapopulation`, and
   `Metacommunity`. Note that a model being at the `Population` or `Community`
   scale doesn't preclude it from being turned into reaction-diffusion models on
   spatial graphs, however `Metapopulation` and `Metacommunity` models are such
   that they have no corresponding local version (think Hanksi's metapopulation
   model).  

2. `Measurement` refers to the type of information that is changing over time in
   a given model. There options here are (1) `Occupancy`, which indicates binary
   presence/absence state, (2) `Abundance`, where each state is a non-negative
   integer representing the count of individuals and (3) `Biomass`, where each
   state is a non-negative real number indicating some relative measure of
   biomass.  

3. `Discreteness` refers to whether a model is defined in `Continuous` or
   `Discrete` time.

4. `Spatialness` refers to whether a constructed model is only occuring at a
   single location (`Local`), or whether the model is constructed across a
   spatial graph (`Spatial`). This type-parameter is distinct because it can
   change. The method `spatialize` transforms a `Local` model into spatial
   models. 


### Spatial graphs 

The `SpatialGraph` type contains information about the coordinates of each
patch/node, as well as environmental covariates at each site. Environmental
covariates are stored in a dictionary where the key is the name of the variable,
and the value is a vector of values corresponds to each node in the spatial
graph. 

### Species Pool

The `SpeciesPool` type contains a list of species names (as `String`s or
`Symbol`s), and more importantly a dictionary of named trait values. The trait
values are important as they are one of two inputs to a `Niche`, which enables
variation in model parameters across space as a function of  enviornmental
conditions.

### Niches

- Provide a default niche function for each model, but enable it to be written
  custom. This enables environment-contigent interaction strengths, etc. 
- Generally, the default niche will modify the growth rates in a model by a
  a function of the distance between a single dimensional environmental variable
  and a species trait, e.g. adjusting $R_0$ in the SIR model  

## Dispatch patterns

- What is the lifespan of building and running a model?
- Maybe there is a figure for the paper here, flowchart of what is the next
  method you run based on what you are trying to do?


## QA Methods for Included Models

One main design goal of `MetacommunityDynamics.jl` is to ensure it is as easy as possible
to write customs models. "Easy", in this sense, means both involving writing the
fewest lines of code possible, and not requiring a deep understanding of Julia
or its type system. 

This means that the instructions on how to add custom models (see TBD docs
section) doesn't include some of the extra methods added to included models to
avoid possible mistakes. e.g.:
- Warnings about parameter values that are extreme or nonsensical (providing an
  intrinsic growth rate to a predator in a LV model, say)
- Warnings about whether a niche function leads toward "crucial" parameters
  going to 0/unreasonable values at most sites depending on the range of
  environmnetal variables provided in the SpatialGraph
