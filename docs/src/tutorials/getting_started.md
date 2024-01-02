# Getting started with `EcoDynamics.jl`

!!! abstract
    In this tutorial, we will install Julia and `EcoDynamics.jl`, and create and simulate a simple model of population dynamics.  


## Installation 

### Installing `Julia`


### Installing `EcoDynamics.jl`


## Hello World in `EcoDynamics.jl`


First we'll load the package.

```@example 1
using MetacommunityDynamics
```

```@example 2   
logistic_model = LogisticMap()
```

```@example 3
prob = problem(logistic_model)
```

```@example 4
traj = simulate(prob)
```

