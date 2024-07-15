module ParametricSpeciesSexSumType

using Random: shuffle
using DynamicSumTypes
using IteratorSampling: itsample

export World
export Species, PlantSpecies, AnimalSpecies, Grass, Sheep, Wolf
export Sex, Female, Male
export Agent, Plant, Animal
export agent_step!, eat!, eats, find_food, reproduce!, world_step!, agent_count

abstract type AbstractAgent end

abstract type Species end
abstract type PlantSpecies <: Species end
abstract type AnimalSpecies <: Species end
abstract type Grass <: PlantSpecies end
abstract type Sheep <: AnimalSpecies end
abstract type Wolf <: AnimalSpecies end

abstract type Sex end
abstract type Male <: Sex end
abstract type Female <: Sex end

mutable struct Animal{A<:AnimalSpecies,S<:Sex}
    id::Int
    energy::Float64
    Δenergy::Float64
    reprprob::Float64
    foodprob::Float64
end

mutable struct Plant{P<:PlantSpecies}
    id::Int
    size::Int
    max_size::Int
end

@sumtype Agent(
    Animal{Wolf,Female},
    Animal{Wolf,Male},
    Animal{Sheep,Female},
    Animal{Sheep,Male},
    Plant{Grass}
) <: AbstractAgent



include("world.jl")
include("plant.jl")
include("animal.jl")
include("utils.jl")

agent_step!(a::Agent, w::World) = agent_step!(variant(a), w)
kill_agent!(agent, w::World) = delete!(w.agents, agent.id)
find_agent(a::Agent, w::World) = Agent(find_agent(typeof(variant(a)), w))

function find_agent(::Type{A}, w::World, predicate=x -> isa(variant(x),A)) where A
    # agents = Iterators.filter(predicate, w.agents |> values) |> collect
    # isempty(agents) ? nothing : variant(itsample(agents))
    agents = Iterators.filter(predicate, w.agents |> values)
    isempty(agents) ? nothing : variant(itsample(agents))
end

# for accessing NamedTuple in World
tosym(a::Agent) = tosym(typeof(variant(a)))

# NOTE: needed for type stability
# TODO: do this with meta programming
tosym(::Type{Animal{Wolf,Female}}) = Symbol("WolfFemale")
tosym(::Type{Animal{Wolf,Male}}) = Symbol("WolfMale")
tosym(::Type{Animal{Sheep,Female}}) = Symbol("SheepFemale")
tosym(::Type{Animal{Sheep,Male}}) = Symbol("SheepMale")
tosym(::Type{Plant{Grass}}) = Symbol("Grass")

end # module
