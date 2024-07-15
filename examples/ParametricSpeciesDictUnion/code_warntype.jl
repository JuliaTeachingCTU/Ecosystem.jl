using Ecosystem

s1 = Sheep(1; sex=:male)
s2 = Sheep(2; sex=:female)
w1 = Wolf(3)

w = World([s1, s2, w1])
display(w)

@code_warntype Ecosystem.find_agent(Animal{Sheep}, w)
Ecosystem.find_agent(Animal{Sheep}, w)

@code_warntype find_food(w1, w)
find_food(w1, w)

sheep = Sheep(1)
world = World(vcat([sheep], [Grass(i) for i in 2:3000]))
@code_warntype find_food(sheep, world)
