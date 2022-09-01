module Ecosystem

using StatsBase
using Random: shuffle, randperm

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

kill_agent!(a::Agent, w::World) = delete!(w.agents, a.id)

function find_agent(::Type{A}, w::World) where A<:Agent
    as = w.agents |> values |> collect
    #a = nothing
    #for i in randperm(length(as))
    #    if isa(as[i],A)
    #        a = as[i]
    #    end
    #end
    #return a
    as = filter(x -> isa(x,A), as)
    isempty(as) ? nothing : sample(as)
end

# for accessing NamedTuple in World
tosym(::T) where T<:Animal = tosym(T)

# NOTE: needed for type stability
# TODO: do this with meta programming
tosym(::Type{Animal{Wolf}}) = Symbol("Wolf")
tosym(::Type{Animal{Sheep}}) = Symbol("Sheep")
tosym(::Type{Plant{Grass}}) = Symbol("Grass")

end # module
