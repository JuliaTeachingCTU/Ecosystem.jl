using Ecosystems.ParametricSpeciesSexNTuple
using BenchmarkTools
using Random
Random.seed!(0)

sheep = Sheep(1, 1, 1, 1, 1, Female)
sheep2 = Sheep(3001, 1, 1, 1, 1, Male)
world = World(vcat([sheep, sheep2], [Grass(i) for i in 2:3000]))

@info "Benching..." typeof(world) find_food(sheep, world)
#find_food(sheep,world) |> display
#@code_warntype find_food(sheep, world)
@btime find_food($sheep, $world)

#@code_warntype reproduce!(sheep, world)
@btime reproduce!($sheep, $world)

# using Ecosystem
# using BenchmarkTools
# using Random
# Random.seed!(0)
# 
# sheep = Sheep(1,1,1,1,1,Female)
# sheep2 = Sheep(3001,1,1,1,1,Male)
# world = World(vcat([sheep,sheep2], [Grass(i) for i=2:3000]))
# find_food(sheep,world) |> display
# 
# sheep = Sheep(1,1,1,1,1,Female)
# sheep2 = Sheep(3001,1,1,1,1,Male)
# world = World(vcat([sheep,sheep2], [Grass(i) for i=2:3000]))
# @code_warntype find_food(sheep, world)
# 
# sheep = Sheep(1,1,1,1,1,Female)
# sheep2 = Sheep(3001,1,1,1,1,Male)
# world = World(vcat([sheep,sheep2], [Grass(i) for i=2:3000]))
# @btime find_food($sheep, $world)
# 
# sheep = Sheep(1,1,1,1,1,Female)
# sheep2 = Sheep(3001,1,1,1,1,Male)
# world = World(vcat([sheep,sheep2], [Grass(i) for i=2:3000]))
# reproduce!(sheep, world)
# 
# sheep = Sheep(1,1,1,1,1,Female)
# sheep2 = Sheep(3001,1,1,1,1,Male)
# world = World(vcat([sheep,sheep2], [Grass(i) for i=2:3000]))
# @code_warntype reproduce!(sheep, world)
# 
# sheep = Sheep(1,1,1,1,1,Female)
# sheep2 = Sheep(3001,1,1,1,1,Male)
# world = World(vcat([sheep,sheep2], [Grass(i) for i=2:3000]))
# @btime reproduce!($sheep, $world)
