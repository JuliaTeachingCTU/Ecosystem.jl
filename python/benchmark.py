import time

from ecosystem import World, Sheep, Wolf, Grass, find_food, Sex, reproduce

def bench(f, *args, N=100):
    t = 0
    for _ in range(N):
        t1 = time.time()
        f(*args)
        t2 = time.time()
        t += t2-t1
    print(f"{t / N * 1_000_000} μs")



sheep1 = Sheep(0, sex=Sex.FEMALE)
sheep2 = Sheep(5000, sex=Sex.MALE)
world = World([sheep1, sheep2] + [Grass(i) for i in range(1,3001)])

bench(find_food, sheep1, world)
bench(reproduce, sheep1, world)


# thoughts on the python version:
# the Agent.eat method is slightly less elegant
