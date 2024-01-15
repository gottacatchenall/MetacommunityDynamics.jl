# Getting started with `MetacommunityDynamics.jl`


!!! abstract
    In this tutorial, we create and simulate a simple model of community
    dynamics. We will then build a customized model. Then we'll make it spatial.
    Then we'll add stochasticity. Then we'll add niche effects. And that'll be
    the end of this tutorial.


In this tutorial, we will learn how to use `MetacommunityDynamics.jl` from
scratch. We'll start by learning how to simulate Lotka-Volterra dynamics, how to
adjust model parameters and how to change differential equation solvers. In the
secont part, we'll focus on how MetacommunityDynamics.jl enables
reaction-diffusion dynamics on spatial graphs, where we'll simulate how
dispersal causes an LV system across many patches to become synchronized.

Let's start by loading the package. If you have not installed Julia or
MetacommunityDynamics, see this [installation guide](TODO).


```@example 1
using MetacommunityDynamics
```

# A simple Lotka-Volterra Model

`MetacommunityDynamics.jl` includes a library of many common models for
population and community dynamics. 

```@example 1
lv = TrophicLotkaVolterra()
```

```@example 1
prob = problem(lv)
```

```@example 1
traj = simulate(prob);
makieplot(traj)
```

### Changing parameters

foo

```@example 1
lv_custom_params = TrophicLotkaVolterra(λ = 0.1, γ = 0.3)
traj = simulate(problem(lv_custom_params))
makieplot(traj)
```

### Changing the simulation length

foo

```@example 1
prob = problem(lv, tspan=(1,200))
makieplot(simulate(prob))
```

### Changing the initial condition

foo

```@example 1
prob = problem(lv, u0 = [0.5, 0.5])
makieplot(simulate(prob))
```

### Using a custom differential-equation solver

bar

```@example 1
using DifferentialEquations
prob = problem(lv)
makieplot(simulate(prob, solver=Vern7()))
```

foo


# Making our model spatial

```@example 1
coords = Coordinates(20);
makieplot(coords)
```

foo

```@example 1
kern = DispersalKernel(decay=3., max_distance=1.5);
makieplot(kern)
```

bar

```@example 1
sg = SpatialGraph(coords, kern);
makieplot(sg)
```

foobar

```@example 1
spatial_lv = spatialize(lv, sg, SpeciesPool(2));
```

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
    u0=rand(2,numsites(sg)),
    tspan=(1,300)
);

t = simulate(spatial_prob)
makieplot(t)
```

Notice the difference in synchrony