# Getting started with `EcoDynamics.jl`

!!! abstract
    In this tutorial, we will install Julia and `EcoDynamics.jl`, and create and simulate a simple model of population dynamics.  


First we'll load the package. 

```@example 1
using MetacommunityDynamics
```

```@example 2   
logistic_map = LogisticMap(r=[3.6])
```

```@example 3
prob = problem(logistic_map)
```

```@example 4
traj = simulate(prob)
```


```@example 5
coords = Coordinates(20)
```

```@example 6
kern = DispersalKernel(decay=5.0, max_distance=0.5)
```

```@example 7
sg = SpatialGraph(coords, kern)
```

```@example 8
spatial_logmap = spatialize(logistic_map, sg, SpeciesPool(1))
```

```@example 9
diffusion = Diffusion(sg, 0.05)
```

```@example 10
spatial_prob = problem(spatial_logmap, diffusion)
```
```@example 11
simulate(spatial_prob)
```


