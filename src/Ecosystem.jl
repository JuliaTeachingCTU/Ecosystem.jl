module Ecosystem

using StatsBase
using Random: shuffle

export World
export Species, PlantSpecies, AnimalSpecies, Grass, Sheep, Wolf
export Sex, Female, Male
export Agent, Plant, Animal
export agent_step!, eat!, eats, find_food, reproduce!, world_step!, agent_count

abstract type Species end
abstract type Agent{S<:Species} end

abstract type PlantSpecies <: Species end
abstract type Grass <: PlantSpecies end

abstract type AnimalSpecies <: Species end
abstract type Sheep <: AnimalSpecies end
abstract type Wolf <: AnimalSpecies end

include("world.jl")
include("plant.jl")
include("animal.jl")
include("utils.jl")

kill_agent!(a::Agent, w::World) = delete!(getfield(w.agents, tosym(typeof(a))), a.id)

function find_agent(::Type{A}, w::World) where A<:Agent
    dict = get(w.agents, tosym(A), nothing)
    if !isnothing(dict)
        as = dict |> values |> collect
        isempty(as) ? nothing : sample(as)
    else
        nothing
    end
end

# for accessing NamedTuple in World
tosym(::T) where T<:Animal = tosym(T)

# NOTE: needed for type stability
# TODO: do this with meta programming
tosym(::Type{Animal{Wolf}}) = Symbol("Wolf")
tosym(::Type{Animal{Sheep}}) = Symbol("Sheep")
tosym(::Type{Plant{Grass}}) = Symbol("Grass")

end # module
