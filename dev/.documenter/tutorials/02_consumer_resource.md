
# A tutorial on Consumer-Resource Modeling {#A-tutorial-on-Consumer-Resource-Modeling}

::: warning Warning

This is still a work in progress

:::

::: tip Abstract

In this tutorial, we explore our first multi-species model: Lotka-Volterra dynamics. We&#39;ll learn about building consumer-resource models in `MetacommunityDynamics`, and using included and custom functional responses. 

:::

Overview
- Basic LV
  
- Custom functional response
  
- Differential growth in response to environment 
  
- YodzisInnes and trait models
  
- Many species models
  
- Putting it all together
  

First we&#39;ll load the package.

```julia
using MetacommunityDynamics
```


# An introduction to Consumer-Resource models {#An-introduction-to-Consumer-Resource-models}

Lotka-Volterra as a predator-prey model.

The unrealistic assuptions of LV. First, primary production should be density dependent. **TODO EXAMPLE**

Second consumption should follow a functional response as a function of resource density. **TODO EXAMPLE**

Why are CR models of interest? Stability of systems. 

## Lotka-Volterra {#Lotka-Volterra}

It&#39;s included. Just like in previous tutorial we can use the constructor to create an instance of the Lotka-Volterra model:

```julia
lv = TrophicLotkaVolterra()
```


```
[34mLocal[39m [1mTrophicLotkaVolterra[22m
```


and convert it to a `Problem` and `simulate`, just as we did before

```julia
prob = problem(lv)
traj = simulate(prob)
```


```
An [32m[1mtrajectory[22m[32m[39m of length [38;2;144;202;249m101.[39m
                   ┌────────────────────────────────────────┐ 
           1.03775 │⠔⠊⠉⠉⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
                   │⠀⠀⠀⠀⠀⠈⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
                   │⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
                   │⠀⠀⠀⠀⠀⠀⠀⠀⢇⡰⠋⠉⠣⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
                   │⠀⠀⠀⠀⠀⠀⠀⠀⡼⡁⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
                   │⠀⠀⠀⠀⠀⠀⠀⢰⠃⢱⡀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
                   │⠀⠀⠀⠀⠀⠀⢀⠇⠀⠀⢣⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
   Biomass         │⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠀⢇⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
                   │⠀⠀⠀⠀⠀⢰⠁⠀⠀⠀⠀⠈⢆⠀⠀⠀⠀⠙⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
                   │⠀⠀⠀⠀⢠⠃⠀⠀⠀⠀⠀⠀⠈⢢⠀⠀⠀⠀⠈⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
                   │⠀⠀⠀⠀⡎⠀⠀⠀⠀⠀⠀⠀⠀⠈⠣⢄⠀⠀⠀⠈⠣⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡠⠴│ 
                   │⠀⠀⢀⠞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠓⠤⣄⡀⠀⠈⢆⠀⠀⠀⠀⠀⠀⣀⣀⣀⠤⠤⠒⠊⠉⠀⠀⠀│ 
                   │⠀⢀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠯⣉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
                   │⠎⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠒⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
                 0 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠑⠒⠒⠒⠤⠤⠤⠤│ 
                   └────────────────────────────────────────┘ 
                   ⠀0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀100⠀ 
                   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀time (t)⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ 
```


LV and parameterizations. Introduce limit cycles. 

## What is a functional response? {#What-is-a-functional-response?}

Here we build a new model with our own customized functional response.

How the rate of consumption of consumer $C$ of a resource $R$ depends on the density of the resource. This idea was initially described by Holling (YEAR).

The Lotka-Voltera Model has a linear (or also-called Holling Type-I) functional response. Consider the time-derivative of the consumer $C$:

$$\frac{dC}{dt} = \beta CR - \gamma C$$

i.e., for a fixed number of consumers $C$, the transfer of biomass from resource  to consumer is a linear function of the resource amount $R$ as a  function with slope $\beta$.  

This is not realistic. **simple example**.
