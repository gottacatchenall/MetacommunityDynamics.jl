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
MetacommunityDynamics, see this [installation guide].


```@example 1
using MetacommunityDynamics
```

## A simple Lotka-Volterra Model

`MetacommunityDynamics.jl` includes a library of many common models for
population and community dynamics. 

```@ansi 1
lv = TrophicLotkaVolterra()
```

```@ansi 1
prob = problem(lv)
```

```@ansi 1
traj = simulate(prob)
```

### Changing parameters

foo

```@ansi 1
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

```@ansi 1
using DifferentialEquations
prob = problem(lv)
simulate(prob, solver=Vern7())
```

foo


## Making our model spatial

```@ansi 1
coords = Coordinates(20)
```

foo

```@ansi 1
kern = DispersalKernel(decay=3., max_distance=1.5)
```

bar

```@ansi 1
sg = SpatialGraph(coords, kern)
```

foobar

```@ansi 1
spatial_lv = spatialize(lv, sg, SpeciesPool(2))
```

very low migration

```@ansi 1
diffusion = Diffusion(sg, 0.001)
```

foobarbaz

```@ansi 1
spatial_prob = problem(spatial_lv, diffusion; 
    u0=rand(2,numsites(sg)),
    tspan=(1,300)
);
```

foo

```@ansi 1
t = simulate(spatial_prob)
```
biz

Very high migration

```@ansi 1
diffusion = Diffusion(sg, 0.1)

spatial_prob = problem(spatial_lv, diffusion; 
    u0=rand(2,numsites(sg)),
    tspan=(1,300)
)

t = simulate(spatial_prob)
```

Notice the difference in synchrony

## Species specific dispersal

```@ansi 1
diffusion_vec = [Diffusion(sg, 0.1), Diffusion(sg, 0.01)]

spatial_prob = problem(spatial_lv, diffusion_vec; 
    u0=rand(2,numsites(sg)),
    tspan=(1,300)
);

t = simulate(spatial_prob)
```

## Demographic stochasticity

something in the vector of diffusions + stochastic constructor is broken.

```@ansi 1
spatial_prob = problem(spatial_lv, diffusion_vec, GaussianDrift(0.05); 
    tspan=(1,300)
)
```


## Local environmental variation and niche effects


