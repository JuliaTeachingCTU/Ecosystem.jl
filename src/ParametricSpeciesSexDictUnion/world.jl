mutable struct World{T<:Dict{Int}}
    # this is a NamedTuple of Dict{Int,<:Agent}
    # but I don't know how to express that as a parametric type
    agents::T
    max_id::Int
end

function World(agents::Vector{<:Agent})
    ids = [a.id for a in agents]
    length(unique(ids)) == length(agents) || error("Not all agents have unique IDs!")
    types = unique(typeof.(agents))
    d = Dict{Int,Union{types...}}(a.id => a for a in agents)
    World(d, maximum(ids))
end

function flat(w::World)
    xs = map(zip(keys(w.agents), w.agents)) do (name, species)
        map(species |> keys |> collect) do id
            id, name
        end
    end
    Iterators.flatten(xs)
end

function world_step!(world::World)
    ids = copy(keys(world.agents))
    for id in ids
        !haskey(world.agents,id) && continue
        a = world.agents[id]
        agent_step!(a, world)
    end
end

function Base.show(io::IO, w::World)
    println(io, "$(typeof(w))")
    for (_,a) in w.agents
        println(io,"  $a")
    end
end
