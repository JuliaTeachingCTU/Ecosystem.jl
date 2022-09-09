from dataclasses import dataclass


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
