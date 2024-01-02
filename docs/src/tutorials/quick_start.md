# Hellow World in  `EcoDynamics.jl`

!!! abstract

    This is meant as a quick tutorial to show a typical workflow using EcoDynamics.jl. We will introduce many concepts quite quickly in order to show off the features that make `EcoDynamics` tick. If it feels like the content is moving fast, that's okay. More detailed explanations of the functionality showcased here will follow in subsequent parts of the 'Getting Started' guide.

This document is a quick start to the features in `EcoDynamics`. Here we will
build a model of consumer-resource dynamics on a spatial graph, where the
limiting growth rate of the resource is a function of the environmental
conditions at each patch.

First we'll load the package.

```@example 1
using MetacommunityDynamics
```

For this example, we are going to use one of the many models included in the
`EcoDynamics` library. The Rosenzweig-MacArthur [@cite] model of
consumer-resource dynamics. Initially, the Rosenzweig-MacArthur was originally
defined as  

$$\frac{dR}{dt} = \lambda R \bigg(1 - \frac{R}{K}\bigg) - \frac{\alpha CR}{1
+\alpha \eta R}$$

$$\frac{dC}{dt} = \beta \frac{\alpha CR}{1 + \alpha \eta R} - \gamma   C$$

where $R$ is the relative biomass of the resource, $C$ is the relative biomass
of the consumer, $\alpha$ is the attack-rate, $\eta$ is the handling type,
$\lambda$ is the limiting instric growth rate,  $\beta$ is the intrinsic
infintesimal growth of biomass for the consumer per unit resource, and $\gamma$
is the intrinsic death date of consumers. (Note that this is equivalent to a
Lotka-Volterra model with a Holling Type-II functional response).

By default, in `EcoDynamics` the `RosenzweigMacArthur` model is parameterized
for two species exhibiting a limit cycle, though it can be used for an arbitrary
number of species (See _TODO custom parameterization_ section). 

```@example 1
rosen = RosenzweigMacArthur()
```

Here we'll consider the folliwing way in which environmental variation affects
the dynamics of this model.

At each patch $i$ in the spatial graph, the limiting growth rate of the resource
at that patch, $\lambda_i$, is a function of the difference between a given
trait for the consumer species $x$, and a single environmental variable
associated with each patch, $e_i$. 

We'll model $\lambda_i$ as decreasing like a Gaussian as the distance between
$e_i$ and $x$ decreases, e.g. 

$$\lambda_i = \exp{\bigg(\frac{-(e_i -x)^2}{\sigma^2}\bigg)}$$

where $\sigma$ is a parameter controlling the 'importance' of this
trait-environmental matching for consumer growth.


We'll first do this by initializing a two-species `SpeciesPool`

```@example 1
sp = SpeciesPool(2)
```

Note that by default, `SpeciesPool`s initialized without provided traits default
to a single dimensional trait named `:x` uniformally distributed on $[0,1]$. 

Next, we'll initialize a spatial graph with 20 patches. Note that when not
initialized with environmental variable,`SpatialGraph`'s are initialized with a
single environmental varaible `:e1`, similarly uniformally drawn from $[0,1]$.

```@example 1
sg = SpatialGraph(Coordinates(20), DispersalKernel(max_distance=0.3))
```

Now, we provide a function that encodes our model of the niche as described
above. Note that a niche function is expected to take a `model`, `traits`, and
particular patch's environmental condition, and return the modified the parameters for that
particular _patch_.


```@example 1
function niche(model, traits, local_env)
    θ = paramdict(model)
    θ[:λ] = [λᵢ > 0 ? λᵢ*exp(-(traits[:x][i] - local_env[:e])^2) : 0 for (i,λᵢ) in enumerate(θ[:λ])]
    return θ
end
```

Now, we use the `spatialize` method to combine our `Model`, `SpatialGraph`,
`SpeciesPool`, and `niche`. Note that `niche` here is a keyword argument. If not
provided, by default spatialize will used identical parameters across all sites.
This may be of interested if the goal is understanding the consequences of
dispersal absent environmental variation.

```@example 1
spatialrm = spatialize(rosen, sg, sp; niche=niche)
```

The final thing we need to run this model is our `Diffsion` model.
`Diffusion` models are constructed using a few components, first a
`DispersalKernel`. The dispersal kernel describes a relative likeliheed of how
far an individual organism is going to disperse. By default,
the `DispersalKernel`s are initialized with an exponential dispersal kernel,
i.e. the kernel $f$ is given by 

$$f(x, \alpha) = e^{-\alpha d_{ij}}$$

where $\alpha$ indicates the strength of decay, i.e. for small $\alpha$ the
organism can disperse far, and vice-versa, and $d_{ij}$ is the distance between
patch $i$ and patch $j$.  The `DispersalKernel` also takes an optional
`max_distance` argument, which is the furthest any organism can feasibly
disperse, meaning for any $d_{ij}$ greater than the `max_distance`, the kernel
will be equal to zero. 


Finally, we can define our `Diffusion` model using a base migration probability and the dispersal potential.

```@example 1
m = 0.01
diff = Diffusion(m, sg)
```
Now, we can finally construct the a `Problem` using our local dynamics
`spatialrm` model and our diffusion model `diff`. Initial conditions and
timespan can be provided here.

```@example 1
prob = problem(spatialrm, diff)
```

and run the model using `simulate`

```@example 1
simulate(prob)
```