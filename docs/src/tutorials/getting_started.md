# Getting started with `EcoDynamics.jl`

!!! abstract
    In this tutorial, we will install Julia and `EcoDynamics.jl`, and create and simulate a simple model of population dynamics.  


First we'll load the package. 

```@example 1
using MetacommunityDynamics
```

```@example 1
logistic_map = LogisticMap(r=[3.6])
```

```@example 1
prob = problem(logistic_map)
```

```@example 1
traj = simulate(prob)
```


```@example 1
coords = Coordinates(20)
```

```@example 1
kern = DispersalKernel(decay=5.0, max_distance=0.5)
```

```@example 1
sg = SpatialGraph(coords, kern)
```

```@example 1
spatial_logmap = spatialize(logistic_map, sg, SpeciesPool(1))
```

```@example 1
diffusion = Diffusion(sg, 0.05)
```

```@example 1
spatial_prob = problem(spatial_logmap, diffusion)
```
```@example 1
simulate(spatial_prob)
```


