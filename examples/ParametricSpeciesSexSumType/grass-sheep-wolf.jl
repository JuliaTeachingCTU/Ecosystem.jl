using Ecosystems.ParametricSpeciesSexSumType
using Random
using Plots
Random.seed!(4)

function make_counter()
    n = 0
    counter() = n += 1
end

function create_world()
    n_grass  = 2_000
    n_sheep  = 80
    n_wolves = 4

    nextid = make_counter()

    World(vcat(
        [Grass(nextid()) for _ in 1:n_grass],
        [Sheep(nextid()) for _ in 1:n_sheep],
        [Wolf(nextid()) for _ in 1:n_wolves],
    ))
end
world = create_world();

counts = Dict(n=>[c] for (n,c) in agent_count(world))
for _ in 1:200
    world_step!(world)
    for (n,c) in agent_count(world)
        push!(counts[n],c)
    end
end

plt = plot()
for (A,c) in counts
    plot!(plt, c, label="$A", lw=2)
end
display(plt)
#error()

function simulate!(world::World, iters::Int)
    for i in 1:iters
        world_step!(world)
    end
end

using BenchmarkTools
using DynamicSumTypes
N = 10
world = create_world();


sheep = variant(Sheep(world.max_id+1))
@btime find_food($sheep, $world)

@btime simulate!($world, $N)

world = create_world();
@profview simulate!(world, N)
