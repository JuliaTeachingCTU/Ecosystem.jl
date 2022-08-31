using Ecosystem
using Test

@testset "Ecosystem.jl" begin
    # Base.show
    g = Grass(1,1,1)
    s = Animal{Sheep,Male}(2,1,1,1,1)
    w = Animal{Wolf,Female}(3,1,1,1,1)
    @test repr(g) == "🌿  #1 100% grown"
    @test repr(s) == "🐑♂ #2 E=1.0 ΔE=1.0 pr=1.0 pf=1.0"
    @test repr(w) == "🐺♀ #3 E=1.0 ΔE=1.0 pr=1.0 pf=1.0"
    @test_nowarn repr(World([g,s,w]))

    # World creation with same ID agents throws error
    g = Grass(1,10)
    @test_throws ErrorException World([g,g])

    grass1 = Grass(1,1,2)
    grass2 = Grass(2,2,2)
    sheep  = Sheep(3,2.0,1.0,0.0,0.0,Female)
    wolf   = Wolf(4,10.0,5.0,0.0,0.0,Male)
    world  = World([grass1,grass2,sheep,wolf])

    # check growth
    @test grass1.size == 1
    agent_step!(grass1,world)
    @test grass1.size == 2
    agent_step!(grass1,world)
    @test grass1.size == 2

    # check energy reduction
    agent_step!(sheep,world)
    @test sheep.energy == 1.0
    agent_step!(wolf,world)
    @test wolf.energy == 9.0

    # check sheep eating grass
    grass1 = Grass(2,2,2)
    sheep  = Sheep(3,2.0,1.0,0.0,1.0,Male)
    world  = World([grass1,sheep])
    agent_step!(sheep,world)
    @test sheep.energy == 3.0
    @test grass1.size == 0.0
    agent_step!(sheep,world)
    @test sheep.energy == 2.0

    # set repr prop to 1.0 and let the sheep reproduce
    sheep1 = Sheep(1,2.0,1.0,1.0,1.0,Male)
    sheep2 = Sheep(2,2.0,1.0,1.0,1.0,Female)
    world = World([sheep1,sheep2])
    agent_step!(sheep1,world)
    @test length(world.agents.sheep_female) == 1
    @test length(world.agents.sheep_male) == 2
    @test sheep1.energy == 0.5

    # check wolf eating sheep
    sheep = Sheep(1,2.0,1.0,0.0,1.0,Male)
    wolf  = Wolf(2,10.0,5.0,0.0,1.0,Female)
    world = World([sheep,wolf])
    agent_step!(wolf, world)
    @test wolf.energy == 19.0
    @test length(world.agents.sheep_male) == 0
    @test length(world.agents.wolf_female) == 1

    ss = [Sheep(1,5.0,2.0,1.0,1.0,Female),Sheep(2,5.0,2.0,1.0,1.0,Male)]
    world = World(ss)
    world_step!(world)
    @test length(world.agents.sheep_female) == 2
    @test length(world.agents.sheep_male) == 2
    world_step!(world)
    @test length(world.agents.sheep_female) == 4
    @test length(world.agents.sheep_male) == 4
    world_step!(world)
    @test length(world.agents.sheep_female) == 0
    @test length(world.agents.sheep_male) == 0

end
