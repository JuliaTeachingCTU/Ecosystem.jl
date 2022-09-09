from enum import Enum
from dataclasses import dataclass
import random


@dataclass
class Agent:
    id: int

class World:

    def __init__(self, agents: list[Agent]):
        ids = [a.id for a in agents]
        if len(set(ids)) != len(agents):
            raise ValueError("Not all agents have unique IDs!")

        self.agents = {a.id: a for a in agents}
        self.max_id = max(ids)

    def __str__(self):
        return "\n".join(["World"] + [f" {a}" for a in self.agents.values()])

    def step(self):
        ids = list(self.agents.keys())
        for id in ids:
            if id not in self.agents:
                continue
            a = self.agents[id]
            a.step(self)

    def agent_count(self):
        count = {}
        for a in self.agents.values():
            k = f"{type(a).__name__}"
            if k in count:
                count[k] += a.agent_count()
            else:
                count[k] = a.agent_count()
        return count


##########  Plant  #############################################################

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


##########  Animal  #############################################################

class Sex(Enum):
    FEMALE = 0
    MALE = 1


def randsex():
    return random.choice(list(Sex))


@dataclass
class Animal(Agent):
    energy: float
    denergy: float
    reprprob: float
    foodprob: float
    sex: Sex = randsex()

    def __str__(self):
        t = type(self).__name__
        s = "♀" if self.sex == Sex.FEMALE else "♂"
        i = self.id
        e = self.energy
        d = self.denergy
        r = self.reprprob
        f = self.foodprob
        return f"{t} {s} #{i} E={e} ΔE={d} pr={r} pf={f}"

    def step(self, world):
        self.energy -= 1

        if random.random() <= self.foodprob:
            dinner = find_food(self, world)
            self.eat(dinner, world)

        if self.energy <= 0:
            kill_agent(self, world)

        if random.random() <= self.reprprob:
            reproduce(self, world)

    def mates(self, a: Agent):
        return isinstance(a, type(self)) and (a.sex != self.sex)

    def agent_count(self):
        return 1


@dataclass
class Sheep(Animal):
    energy: float = 4.0
    denergy: float = 0.2
    reprprob: float = 0.5
    foodprob: float = 0.9

    def eats(self, a: Agent):
        return isinstance(a, Grass)

    def eat(self, a: Agent, w: World):
        if a is None:
            return
        elif self.eats(a):
            self.energy += a.size * self.denergy
            a.size = 0
        else:
            raise ValueError(f"Sheep cannot eat {type(a).__name__}.")


@dataclass
class Wolf(Animal):
    energy: float = 10.0
    denergy: float = 8.0
    reprprob: float = 0.1
    foodprob: float = 0.2

    def eats(self, a: Agent):
        return isinstance(a, Sheep)

    def eat(self, a: Agent, w: World):
        if a is None:
            return
        elif self.eats(a):
            self.energy += a.energy * self.denergy
            kill_agent(a, w)
        else:
            raise ValueError(f"Wolves cannot eat {type(a).__name__}.")


def find_food(a: Agent, w: World):
    agents = list(filter(lambda x: a.eats(x), w.agents.values()))
    return random.choice(agents) if len(agents) > 0 else None

def find_mate(a: Agent, w: World):
    agents = list(filter(lambda x: a.mates(x), w.agents.values()))
    return random.choice(agents) if len(agents) > 0 else None

def kill_agent(a: Agent, w: World):
    w.agents.pop(a.id)

def reproduce(a: Animal, w: World):
    m = find_mate(a, w)
    if m is not None:
        a.energy = a.energy / 2
        new_id = w.max_id + 1
        b = type(a)(new_id, a.energy, a.denergy, a.reprprob, a.foodprob, randsex())
        w.agents[b.id] = b
        w.max_id = new_id
