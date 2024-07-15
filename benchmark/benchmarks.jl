using BenchmarkTools
using Pkg
Pkg.status()
Pkg.add("DynamicSumTypes")
Pkg.update()
using DynamicSumTypes
using Ecosystems: ParametricSpeciesDictUnion as PSDU
using Ecosystems: ParametricSpeciesSexDictUnion as PSSDU
using Ecosystems: ParametricSpeciesSexNTuple as PSST
using Ecosystems: ParametricSpeciesNTuple as PST
using Ecosystems: ParametricSpeciesSexSumType as PSSDST
using Random

const SUITE = BenchmarkGroup()

SUITE["ParametricSpeciesDictUnion"] = BenchmarkGroup()

let
    sheep = PSSDST.Sheep(1, 1, 1, 1, 1, PSSDST.Female)
    vsheep = variant(sheep)
    sheep2 = PSSDST.Sheep(3001, 1, 1, 1, 1, PSSDST.Male)
    world = PSSDST.World(vcat([sheep, sheep2], [PSSDST.Grass(i) for i in 2:3000]))
    @info "Benching..." typeof(world) PSSDST.find_food(vsheep, world)
    SUITE["ParametricSpeciesSexSumType"]["find_food"] = @benchmarkable PSSDST.find_food(
        $vsheep, $world
    )
    SUITE["ParametricSpeciesSexSumType"]["reproduce"] = @benchmarkable PSSDST.reproduce!(
        $vsheep, $world
    )
end

let
    sheep = PSDU.Sheep(1, 1, 1, 1, 1, :female)
    sheep2 = PSDU.Sheep(3001, 1, 1, 1, 1, :male)
    world = PSDU.World(vcat([sheep, sheep2], [PSDU.Grass(i) for i in 2:3000]))
    @info "Benching..." typeof(world) PSDU.find_food(sheep, world)
    SUITE["ParametricSpeciesDictUnion"]["find_food"] = @benchmarkable PSDU.find_food($sheep, $world)
    SUITE["ParametricSpeciesDictUnion"]["reproduce"] = @benchmarkable PSDU.reproduce!(
        $sheep, $world
    )
end

let
    sheep = PST.Sheep(1, 1, 1, 1, 1, :female)
    sheep2 = PST.Sheep(3001, 1, 1, 1, 1, :male)
    world = PST.World(vcat([sheep, sheep2], [PST.Grass(i) for i in 2:3000]))
    @info "Benching..." typeof(world) PST.find_food(sheep, world)
    SUITE["ParametricSpeciesNTtuple"]["find_food"] = @benchmarkable PST.find_food($sheep, $world)
    SUITE["ParametricSpeciesNTtuple"]["reproduce"] = @benchmarkable PST.reproduce!($sheep, $world)
end

let
    sheep = PSSDU.Sheep(1, 1, 1, 1, 1, PSSDU.Female)
    sheep2 = PSSDU.Sheep(3001, 1, 1, 1, 1, PSSDU.Male)
    world = PSSDU.World(vcat([sheep, sheep2], [PSSDU.Grass(i) for i in 2:3000]))
    @info "Benching..." typeof(world) PSSDU.find_food(sheep, world)
    SUITE["ParametricSpeciesSexDictUnion"]["find_food"] = @benchmarkable PSSDU.find_food(
        $sheep, $world
    )
    SUITE["ParametricSpeciesSexDictUnion"]["reproduce"] = @benchmarkable PSSDU.reproduce!(
        $sheep, $world
    )
end

let
    sheep = PSST.Sheep(1, 1, 1, 1, 1, PSST.Female)
    sheep2 = PSST.Sheep(3001, 1, 1, 1, 1, PSST.Male)
    world = PSST.World(vcat([sheep, sheep2], [PSST.Grass(i) for i in 2:3000]))
    @info "Benching..." typeof(world) PSST.find_food(sheep, world)
    SUITE["ParametricSpeciesSexNTuple"]["find_food"] = @benchmarkable PSST.find_food($sheep, $world)
    SUITE["ParametricSpeciesSexNTuple"]["reproduce"] = @benchmarkable PSST.reproduce!(
        $sheep, $world
    )
end
