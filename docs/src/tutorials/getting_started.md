# Getting started with `EcoDynamics.jl`

!!! abstract
    In this tutorial, we create and simulate a simple model of community
    dynamics. We will then build a customized model. Then we'll make it spatial.
    Then we'll add stochasticity. Then we'll add niche effects. And that'll be
    the end of this tutorial.


First we'll load the package. 

```@example 1
using MetacommunityDynamics
```

## A simple Lotka-Volterra Model

```@example 1
lv = TrophicLotkaVolterra()
```

```@example 1
prob = problem(lv)
```

```@example 1
traj = simulate(prob);
```

### Changing parameters

foo

```@example 1
lv_custom_params = TrophicLotkaVolterra(λ = 0.1, γ = 0.3)
simulate(problem(lv_custom_params))
```

### Changing the simulation length

foo

```@example 1
prob = problem(lv, tspan=(1,200))
simulate(prob)
```

### Changing the initial condition

foo

```@example 1
prob = problem(lv, u0 = [0.5, 0.5])
simulate(prob)
```

### Using a custom differential-equation solver

bar

```@example 1
using DifferentialEquations
prob = problem(lv)
simulate(prob, solver=Vern7())
```

foo


## Adding space

```@example 1
coords = Coordinates(10);
```

foo

```@example 1
kern = DispersalKernel(decay=5.0, max_distance=0.5);
```

foo

```@example 1
makieplot(kern)
```

bar

```@example 1
sg = SpatialGraph(coords, kern);
```


foo

```@example 1
makieplot(sg)
```

foobar

```@example 1
spatial_lv = spatialize(lv, sg, SpeciesPool(2));
```

baz

very low migration

```@example 1
diffusion = Diffusion(sg, 0.001)
```

foobarbaz

```@example 1
spatial_prob = problem(spatial_lv, diffusion; 
    u0=rand(2,numsites(sg)),
    tspan=(1,300)
);
```

foo

```@example 1
t = simulate(spatial_prob)
makieplot(t)
```
biz

Very high migration

```@example 1
diffusion = Diffusion(sg, 0.1)

spatial_prob = problem(spatial_lv, diffusion; 
    u0=rand(2,10),
    tspan=(1,300)
);

t = simulate(spatial_prob)
makieplot(t)
```

Notice the difference in synchrony