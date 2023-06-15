# Inferring community dynamics

This use case shows how to build and run a model of community dynamics (the
Rosenzweig-MacArthur model, specifically).

```@example 1
using MetacommunityDynamics
```

The _Rosenzweig-MacArthur_ model is a model of consumer-resource dynamics. 

It is described by the equations 

$$\frac{dR}{dt} = \lambda R \bigg(1 - \frac{R}{K}\bigg) - \frac{\alpha CR}{1 +\alpha \eta R}$$
$$\frac{dC}{dt} = \frac{\alpha CR}{1 + \alpha \eta R} - \gamma   C$$

where $R$ is the relative biomass of the resource, $C$ is the relative biomass
of the consumer, $\alpha$ is the attack-rate, $\eta$ is the handling type,
$\lambda$ is the maximum instric growth rate,  $\beta$ is the intrinsic
infintesimal growth of biomass for the consumer per unit resource, and $\gamma$
is the intrinsic death date of consumers. Note that this is equivalent to a
Lotka-Volterra model with a Holling Type-II functional response. 

Let's simulate it. 

```@example 1

rm = RosenzweigMacArthur()
p = problem(rm, Deterministic)
@time sol = simulate(p)

```