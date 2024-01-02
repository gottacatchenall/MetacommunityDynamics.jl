# Our First Two-Species Model

!!! abstract
    In this tutorial, we explore our first multi-species model: Lotka-Volttera
    dynamics.  


First we'll load the package.

```@example 1
using MetacommunityDynamics
```


```@example 2
lv = TrophicLotkaVolterra()
```

```@example 3
prob = problem(lv)
```

```@example 4
traj = simulate(prob)
```

