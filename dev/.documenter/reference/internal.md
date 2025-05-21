
# Documentation for internal methods {#Documentation-for-internal-methods}
<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.BevertonHolt' href='#MetacommunityDynamics.BevertonHolt'><span class="jlbinding">MetacommunityDynamics.BevertonHolt</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
BevertonHolt{S} <: Model{Population,Biomass,S,Discrete}
```


The [Beverton-Holt model](https://en.wikipedia.org/wiki/Beverton%E2%80%93Holt_model) is a discrete-time, deterministic model of population dynamics. It is commonly interpreted as a discrete-time version of the logistic model.

It is described by 

$N_{t+1} =\frac{R_0 M}{N_t + M}N_t$

where $K = (R\_0 - 1)M$ is the carrying capacity.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/models/bevertonholt.jl#L1-L15" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.CompetitiveLotkaVolterra' href='#MetacommunityDynamics.CompetitiveLotkaVolterra'><span class="jlbinding">MetacommunityDynamics.CompetitiveLotkaVolterra</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
CompetitiveLotkaVolterra{S} <: Model{Community,Biomass,S,Continuous}
```


Competitive Lotka-Voterra.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/models/lvcompetition.jl#L1-L5" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Coordinates' href='#MetacommunityDynamics.Coordinates'><span class="jlbinding">MetacommunityDynamics.Coordinates</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Coordinates{T <: Number}
```


A `Coordinates` consists of a set of nodes with coordinates and associated environmental variables for each site.  


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/coordinates.jl#L2-L7" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Coordinates-Tuple{E} where E<:EnvironmentLayer' href='#MetacommunityDynamics.Coordinates-Tuple{E} where E<:EnvironmentLayer'><span class="jlbinding">MetacommunityDynamics.Coordinates</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
Coordinates(layer::E; coords = [(rand(), rand()) for _ = 1:20]) where E<:EnvironmentLayer
```


Builds a `Coordinates` where the environmental variable is built from a single EnvironmentLayer, and optionally the set of coordinates can be passed as a keyword argument.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/coordinates.jl#L93-L99" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Coordinates-Tuple{Integer}' href='#MetacommunityDynamics.Coordinates-Tuple{Integer}'><span class="jlbinding">MetacommunityDynamics.Coordinates</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
Coordinates(n::Integer)
```


Builds a coordinate set with `n` nodes in it.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/coordinates.jl#L126-L130" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Coordinates-Tuple{}' href='#MetacommunityDynamics.Coordinates-Tuple{}'><span class="jlbinding">MetacommunityDynamics.Coordinates</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
Coordinates(; coords = nothing, env = nothing)
```


Builds a `Coordinates`, where both the coordinates and the environmental variables can be passed as keyword arguments. The environment should be a dictionary where (key,value) pairs are names of each environmnetal variable and vectors of that variable across each node in the `Coordinates`.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/coordinates.jl#L104-L111" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Coordinates-Union{Tuple{Dict{S, Vector{T}}}, Tuple{T}, Tuple{S}} where {S<:Union{String, Symbol}, T}' href='#MetacommunityDynamics.Coordinates-Union{Tuple{Dict{S, Vector{T}}}, Tuple{T}, Tuple{S}} where {S<:Union{String, Symbol}, T}'><span class="jlbinding">MetacommunityDynamics.Coordinates</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
Coordinates(env::Dict{S,Vector})
```


Builds a coordinate set for a given environment matrix. The environmental matrix should be a matrix where each column is the vector of environmental variables for each node.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/coordinates.jl#L136-L141" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Coordinates-Union{Tuple{Vector{E}}, Tuple{E}} where E<:EnvironmentLayer' href='#MetacommunityDynamics.Coordinates-Union{Tuple{Vector{E}}, Tuple{E}} where E<:EnvironmentLayer'><span class="jlbinding">MetacommunityDynamics.Coordinates</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
Coordinates(layers::Vector{E}; coords = [(rand(), rand()) for _ = 1:20]) where E<:EnvironmentLayer
```


Builds a coordinate set with environmental variables passed as a vector of EnvironmentLayers, and optionally coordinates passed as a keyword argument. 


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/coordinates.jl#L83-L88" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Coordinates-Union{Tuple{Vector{T}}, Tuple{T}} where T<:Tuple' href='#MetacommunityDynamics.Coordinates-Union{Tuple{Vector{T}}, Tuple{T}} where T<:Tuple'><span class="jlbinding">MetacommunityDynamics.Coordinates</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
Coordinates(coords::Vector{T}) where T<:Tuple
```


Constructs a `Coordinates` from a set of coordinates `coords`, which is a vector of (x,y) pairs. Builds a random environment variable named :x.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/coordinates.jl#L146-L151" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Discreteness' href='#MetacommunityDynamics.Discreteness'><span class="jlbinding">MetacommunityDynamics.Discreteness</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Discreteness
```



<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/types.jl#L37-L39" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.EnvironmentLayer' href='#MetacommunityDynamics.EnvironmentLayer'><span class="jlbinding">MetacommunityDynamics.EnvironmentLayer</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
EnvironmentLayer{T}
```


An `EnvironmentalLayer` stores a raster representation of a single environmental variable inside a matrix.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/environment.jl#L2-L7" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.EnvironmentLayer-Tuple{}' href='#MetacommunityDynamics.EnvironmentLayer-Tuple{}'><span class="jlbinding">MetacommunityDynamics.EnvironmentLayer</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
EnvironmentLayer(; generator = MidpointDisplacement(0.7), sz=(50,50))
```


Builds an `EnvironmentalLayer` with a `NeutralLandscapes` generator


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/environment.jl#L12-L16" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.LogisticMap' href='#MetacommunityDynamics.LogisticMap'><span class="jlbinding">MetacommunityDynamics.LogisticMap</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
LogisticMap{S} <: Model{Population,Biomass,S,Continuous}
```


Logistic Map. 


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/models/logistic_map.jl#L1-L5" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.LogisticModel' href='#MetacommunityDynamics.LogisticModel'><span class="jlbinding">MetacommunityDynamics.LogisticModel</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
LogisticModel{S} <: Model{Population,Biomass,S,Continuous}
```


Logistic Model. 


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/models/logistic_model.jl#L1-L5" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Measurement' href='#MetacommunityDynamics.Measurement'><span class="jlbinding">MetacommunityDynamics.Measurement</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Measurement
```


The Measurement abstract type is a supertype for the different types of _measurements_ a model describes, primarily [`Biomass`]: a continuous value representing relative amount of mass per species, [`Abundance`]: an integer valued count of individuals, and [`Occupancy`]: a binary value of whether is species is present at a location at a given time. 


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/types.jl#L23-L31" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Model' href='#MetacommunityDynamics.Model'><span class="jlbinding">MetacommunityDynamics.Model</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Model{SC<:Scale,M<:Measurement,SP<:Spatialness,D<:Discreteness}
```


The abstract type from all models in MetacommunityDynamics. All `Model`&#39;s are parametric types that stores four parameters that describe the model: [`Scale`], [`Measurement`], [`Spatialness`], and [`Discreteness`]. 

**TODO:**

**change abstract types -&gt; traits,**

`spatialness(t::Model) = Local()` `spatialness(t::Model) = Spatial()`


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/model.jl#L1-L14" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Parameter' href='#MetacommunityDynamics.Parameter'><span class="jlbinding">MetacommunityDynamics.Parameter</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Parameter{T,N}
```


Yet-another Parameter struct. 


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/parameters.jl#L3-L7" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Population' href='#MetacommunityDynamics.Population'><span class="jlbinding">MetacommunityDynamics.Population</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Population
```


The population scale refers to models that describe the population dynamics of a single species at a single local location.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/types.jl#L12-L17" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.RickerModel' href='#MetacommunityDynamics.RickerModel'><span class="jlbinding">MetacommunityDynamics.RickerModel</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
RickerModel
```



<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/models/ricker.jl#L14-L18" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.RickerStochasticityType' href='#MetacommunityDynamics.RickerStochasticityType'><span class="jlbinding">MetacommunityDynamics.RickerStochasticityType</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
RickerStochasticityType
```



<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/models/ricker.jl#L1-L5" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.RosenzweigMacArthur' href='#MetacommunityDynamics.RosenzweigMacArthur'><span class="jlbinding">MetacommunityDynamics.RosenzweigMacArthur</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
struct RosenzweigMacArthur{S<:Spatialness} <: Model{Community,Biomass,S,Continuous}
```


Dynamics given by

$\frac{dR}{dt} = \lambda R \bigg(1 - \frac{R}{K}\bigg) - \frac{\alpha CR}{1 +\alpha \eta R}$

$\frac{dC}{dt} = \beta \frac{\alpha CR}{1 + \alpha \eta R} - \gamma   C$


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/models/rosenzweigmacarthur.jl#L1-L11" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Scale' href='#MetacommunityDynamics.Scale'><span class="jlbinding">MetacommunityDynamics.Scale</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Scale
```


Abstract type that is a supertype for all model scales: [`Population`], [`Metapopulation`], [`Community`], and [`Metacommunity`]. A model&#39;s scale is what it was _orginally_ defined as. For example, [`TrophicLotkaVolterra`] is a [`Community`] model, regardless of whether is has been convert to run on a spatial-graph via [`spatialize`].


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/types.jl#L1-L9" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.SpeciesPool' href='#MetacommunityDynamics.SpeciesPool'><span class="jlbinding">MetacommunityDynamics.SpeciesPool</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
SpeciesPool{T<:Number}
```


A `SpeciesPool` consists of a set of species and their corresponding traits. 


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/species.jl#L2-L6" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.Trajectory' href='#MetacommunityDynamics.Trajectory'><span class="jlbinding">MetacommunityDynamics.Trajectory</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
Trajectory{S<:SciMLBase.AbstractTimeseriesSolution}
```


A trajectory is a single output for a `Problem`.  


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/trajectory.jl#L2-L6" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Base.size-Tuple{Coordinates}' href='#Base.size-Tuple{Coordinates}'><span class="jlbinding">Base.size</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
Base.size(coords::Coordinates)
```


Returns the number of nodes in a coordinate set `coords`.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/coordinates.jl#L14-L18" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics._env_from_layer-Tuple{Any, EnvironmentLayer}' href='#MetacommunityDynamics._env_from_layer-Tuple{Any, EnvironmentLayer}'><span class="jlbinding">MetacommunityDynamics._env_from_layer</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
_env_from_layer(coords, layer::EnvironmentLayer)
```


Returns the values in the layer at the given coordinates, given the bounding-box os the coordinates is the extent of the layer.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/coordinates.jl#L71-L76" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.distance_matrix-Tuple{Coordinates}' href='#MetacommunityDynamics.distance_matrix-Tuple{Coordinates}'><span class="jlbinding">MetacommunityDynamics.distance_matrix</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
distance_matrix(coords::Coordinates; distance = Euclidean())
```


Returns a matrix of pairwise distances for all nodes in a `Coordinates`. The argument passed to `distance` must be of type `Distance` from `Distances.jl`.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/coordinates.jl#L49-L53" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.envdims-Tuple{Coordinates}' href='#MetacommunityDynamics.envdims-Tuple{Coordinates}'><span class="jlbinding">MetacommunityDynamics.envdims</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
envdims(coords::Coordinates)
```


Returns the dimensionality of the environmental variable associated with each node in a `Coordinates` coords.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/coordinates.jl#L22-L27" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.environment-Tuple{Coordinates}' href='#MetacommunityDynamics.environment-Tuple{Coordinates}'><span class="jlbinding">MetacommunityDynamics.environment</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
environment(coords::Coordinates)
```


Returns the dictionary of environmental variables of a `Coordinates` `coords`


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/coordinates.jl#L37-L41" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.numsites-Tuple{Coordinates}' href='#MetacommunityDynamics.numsites-Tuple{Coordinates}'><span class="jlbinding">MetacommunityDynamics.numsites</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
numsites(coords::Coordinates)
```


Returns the number of nodes in a `Coordinates` `coords`. 


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/coordinates.jl#L30-L34" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='MetacommunityDynamics.∂u-Tuple{BevertonHolt, Any, Any}' href='#MetacommunityDynamics.∂u-Tuple{BevertonHolt, Any, Any}'><span class="jlbinding">MetacommunityDynamics.∂u</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
∂u(bm::BevertonHolt, x)
```


Single time-step for the `BevertonHolt` model. 


<Badge type="info" class="source-link" text="source"><a href="https://github.com/gottacatchenall/MetacommunityDynamics.jl/blob/e4071ba39f2f6167974681ac6c4dd22dc0bcdfde/src/models/bevertonholt.jl#L22-L26" target="_blank" rel="noreferrer">source</a></Badge>

</details>

