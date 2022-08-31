using Ecosystem
using Random
using Plots
Random.seed!(8)

function create_world()
    n_grass  = 3000
    n_sheep  = 200
    n_wolves = 1

    gs = [Grass(id) for id in 1:n_grass];
    ss = [Sheep(id) for id in n_grass+1:n_grass+n_sheep];
    wm = [Wolf(id,S=Female) for id in n_grass+n_sheep+1:n_grass+n_sheep+n_wolves];
    wf = [Wolf(id,S=Male) for id in n_grass+n_sheep+n_wolves+1:n_grass+n_sheep+n_wolves*2];
    World(vcat(gs, ss, wm, wf))
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
tolabel(::Type{Animal{Sheep,Female}}) = "Sheep ♀"
tolabel(::Type{Animal{Sheep,Male}}) = "Sheep ♂"
tolabel(::Type{Animal{Wolf,Female}}) = "Wolf ♀"
tolabel(::Type{Animal{Wolf,Male}}) = "Wolf ♂"
tolabel(::Type{Plant{Grass}}) = "Grass"
for (A,c) in counts
    plot!(plt, c, label=tolabel(A), lw=2)
end
display(plt)
#error()

function simulate!(world::World, iters::Int)
    for i in 1:iters
        world_step!(world)
    end
end

using BenchmarkTools
N = 10
world = create_world();
@btime simulate!($world, $N)

world = create_world();
@profview simulate!(world, N)
