import matplotlib.pyplot as plt
from ecosystem import World, Grass, Sheep, Wolf

def make_counter():
    n = 0
    def counter():
        nonlocal n
        n += 1
        return n
    return counter

def create_world():
    n_grass  = 2_000
    n_sheep  = 80
    n_wolves = 4

    nextid = make_counter()

    world = World(
        [Grass(nextid()) for _ in range(n_grass)] \
            + [Sheep(nextid()) for _ in range(n_sheep)] \
                + [Wolf(nextid()) for _ in range(n_wolves)]
    )
    return world

world = create_world()

counts = {n:[c] for (n,c) in world.agent_count().items()}
for _ in range(100):
    world.step()
    for (n,c) in world.agent_count().items():
        counts[n].append(c)


world = create_world()
import time
t1 = time.time()
for _ in range(10):
    world.step()
print(time.time() - t1)

for (n, c) in counts.items():
    plt.plot(c, label=n)
plt.legend()
plt.show()
