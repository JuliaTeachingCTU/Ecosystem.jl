agent_count(p::Plant) = p.size / p.max_size
agent_count(::Animal) = 1
agent_count(as::Vector{<:Agent}) = sum(agent_count,as,init=0)
agent_count(d::Dict) = agent_count(d |> values |> collect)
agent_count(w::World) = Dict(eltype(as |> values)=>agent_count(as) for as in w.agents)
