mutable struct World{T<:NamedTuple}
    # this is a NamedTuple of Dict{Int,<:Agent}
    # but I don't know how to express that as a parametric type
    agents::T
    max_id::Int
end

function World(agents::Vector{<:Agent})
    types = unique(typeof.(agents))
    ags = map(types) do T
        as = filter(x -> isa(x,T), agents)
        Dict{Int,T}(a.id=>a for a in as)
    end
    nt = (; zip(tosym.(types), ags)...)
    
    ids = [a.id for a in agents]
    length(unique(ids)) == length(agents) || error("Not all agents have unique IDs!")
    World(nt, maximum(ids))
end

Base.getindex(w::World, key::Symbol) = get(w.agents, key, nothing)

function flat(w::World)
    xs = map(zip(keys(w.agents), w.agents)) do (name, species)
        map(species |> keys |> collect) do id
            id, name
        end
    end
    Iterators.flatten(xs)
end

function world_step!(world::World)
    # NOTE: we are iterating over (id,key) pairs of the world, which keeps us type stable
    for (id, field) in shuffle(flat(world) |> collect)
        species = getfield(world.agents, field)
        !haskey(species, id) && continue
        a = species[id]
        agent_step!(a, world)
    end
end

function Base.show(io::IO, w::World)
    ts = join([valtype(a) for a in w.agents], ", ")
    println(io, "World[$ts]")
    for dict in w.agents
        for (_,a) in dict
            println(io,"  $a")
        end
    end
end
