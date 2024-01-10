# Getting started with `EcoDynamics.jl`

!!! abstract
    In this tutorial, we will install Julia and `EcoDynamics.jl`, and create and simulate a simple model of population dynamics.  


First we'll load the package. 

```@example 1
using MetacommunityDynamics
```

```@example 1
logistic_map = LogisticMap(r=3.6)
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

foo

```@example 1
kern = DispersalKernel(decay=5.0, max_distance=0.5)
```

bar

```@example 1
sg = SpatialGraph(coords, kern)
```
foobar

```@example 1
spatial_logmap = spatialize(logistic_map, sg, SpeciesPool(1))
```

baz


```@example 1
diffusion = Diffusion(sg, 0.05)
```

foobarbaz

```@example 1
spatial_prob = problem(spatial_logmap, diffusion; u0=[rand() for _ in 1:numsites(sg)])
```

```@example 1
simulate(spatial_prob)
```
biz



