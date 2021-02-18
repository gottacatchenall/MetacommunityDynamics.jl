# MetacommunityDynamics.jl
A Julia libarary for simulating the dynamics of complex species interaction networks, part of [EcoJulia]().


## What can this software do?

This software is design to simulate trajectories of _metacommunity dynamics_.

A metacommunity (Leibold et al. 2004) consists of a species pool distributed 
across a landscape. The composition of metacommunities (what species can be found, and where)
changes over time as move through space, interact with other species, and face selection both 
on conditions imposed by abiotic environment and other species. 

Understanding how metacommunities change over time, their _dynamics_,   
is crucial to understand how ecological mechanisms scale up to determine 
the abundance and distribution of species across space and time.

Vellend (2010) identifies four fundamental processes in community ecology (Dispersal, Niche Selection, Drift, Speciation).

Here we provide data structures to combine `DispersalModel`s, `SelectionModel`s, and `DriftModel`s to 
simulate trajectories of metacommunity dynamics--- both abundance and occupancy of a species pool, 
represented as a `Metaweb`, acrpss a set of points of type `Landscape`.

The goal is to write idiomatic code, like

```
  diffusionParams = (m=0.1,...)
  nicheSelectionParams = (

  model = DiffusionDispersal(diffusionParams...) + DensityDependentSelection(selectionParams) + OccupancyDrift(draftParams)  
  dynamicsTrajectory::DynamicsTrajectory = model()
  
  \alpha::SummaryStat = meanAlphaDiversity(dynamicsTrajectory)
  
  \alpha(dynamicsTrajectory)
```



## How does it work?
See the [design document]().


## Contributing

Open a PR or send me an email.
