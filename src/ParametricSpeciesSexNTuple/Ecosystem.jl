module ParametricSpeciesSexNTuple

using Random: shuffle
using IteratorSampling: itsample

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

abstract type Sex end
abstract type Male <: Sex end
abstract type Female <: Sex end

include("world.jl")
include("plant.jl")
include("animal.jl")
include("utils.jl")

kill_agent!(a::A, w::World) where {A<:Agent} = delete!(w.agents[tosym(A)], a.id)

function find_agent(::Type{A}, w::World) where {A<:Agent}
    dict = w[tosym(A)]
    if !isnothing(dict)
        agents = dict |> values
        isempty(agents) ? nothing : itsample(agents)
    else
        nothing
    end
end

# for accessing NamedTuple in World
tosym(::T) where {T<:Animal} = tosym(T)

# NOTE: needed for type stability
tosym(::Type{Animal{Wolf,Female}}) = Symbol("WolfFemale")
tosym(::Type{Animal{Wolf,Male}}) = Symbol("WolfMale")
tosym(::Type{Animal{Sheep,Female}}) = Symbol("SheepFemale")
tosym(::Type{Animal{Sheep,Male}}) = Symbol("SheepMale")
tosym(::Type{Plant{Grass}}) = Symbol("Grass")

end # module
