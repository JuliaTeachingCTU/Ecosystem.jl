from dataclasses import dataclass
import random
from world import Agent


@dataclass
class Plant(Agent):
    id: int
    size: int
    max_size: int

    def __str__(self):
        t = type(self).__name__
        p = self.size / self.max_size * 100
        return f"{t} #{self.id} {p}% grown"

    def step(self, world):
        if self.size < self.max_size:
            self.size += 1

    def agent_count(self):
        return self.size / self.max_size


@dataclass
class Grass(Plant):
    max_size: int = 10
    size: int = random.randint(0, max_size)

