# MetacommunityDynamics.jl Design Document

## Dependencies and Interface with EcoJulia
- EcoJuliaCore.jl includes abstract data structures `AbstractDataPoint`, `AbstractAssemblage`, etc.
- EcologicalNetworks.jl provides data structures and generative models for food webs
- EcologicalNetworksPlots.jl does data visualization for network properties
- BioenergeticDynamics.jl simulates energy flow dynamics on food-webs based on a revised model of Yodzis and Innes (1992) using `DifferentialEquations.jl`
- SpatialEcology.jl contains data structures for point and raster spatial data


## Data Structures

Split out representation of metacommunities and their dynamics into the following categories

1. Landscape
- Locations
- Dispersal Structure
- Envrionmental Conditions across Space

2. Dynamics
- Measurement (what is the thing that is changing, e.g. abundance, occupancy, traits, phylogenetic distance, etc.)
- DynamicsModel (how does this measure change over time, as a function of the state/environment/etc.)
- DynamicsState a set of Meaurements for each Location
- DynamicsTrajectory a list of DynamicsStates over time  

3. Metacommunity
- EcologicalNetwork



4. Summary Statistics


### Landscape

####  Location

`Location` is a superclass of `SpatialEcology.jl`: `SELocations`, `SESpatialData`.

It represents the

### Species Interaction Network



### Dynamics
- Abundance/occupancy matrix.



#### Locations
