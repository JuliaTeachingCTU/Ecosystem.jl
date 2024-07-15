using Ecosystems.ParametricSpeciesSexDictUnion
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
