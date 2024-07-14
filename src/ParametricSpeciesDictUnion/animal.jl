mutable struct Animal{A<:AnimalSpecies} <: Agent{A}
    id::Int
    energy::Float64
    Δenergy::Float64
    reprprob::Float64
    foodprob::Float64
    sex::Symbol
end

# AnimalSpecies constructors
function (A::Type{<:AnimalSpecies})(id::Int,E::T,ΔE::T,pr::T,pf::T,sex::Symbol) where T
    Animal{A}(id,E,ΔE,pr,pf,sex)
end

# get the per species defaults back
randsex() = rand(Bool) ? :female : :male
Sheep(id; E=4.0, ΔE=0.2, pr=0.5, pf=0.9, sex=randsex()) = Sheep(id, E, ΔE, pr, pf, sex)
Wolf(id; E=10.0, ΔE=4.0, pr=0.1, pf=0.20, sex=randsex()) = Wolf(id, E, ΔE, pr, pf, sex)

function Base.show(io::IO, a::Animal{A}) where A<:AnimalSpecies
    e = a.energy
    d = a.Δenergy
    pr = a.reprprob
    pf = a.foodprob
    s = a.sex == :male ? "♂" : "♀"
    print(io, "$A$s #$(a.id) E=$e ΔE=$d pr=$pr pf=$pf")
end

# note that for new species/sexes we will only have to overload `show` on the
# abstract species types like below!
Base.show(io::IO, ::Type{Sheep}) = print(io,"🐑")
Base.show(io::IO, ::Type{Wolf}) = print(io,"🐺")


function eat!(wolf::Animal{Wolf}, sheep::Animal{Sheep}, w::World)
    wolf.energy += sheep.energy * wolf.Δenergy
    kill_agent!(sheep,w)
end
function eat!(sheep::Animal{Sheep}, grass::Plant{Grass}, w::World)
    sheep.energy += grass.size * sheep.Δenergy
    grass.size = 0
end
eat!(::Animal, ::Nothing, ::World) = nothing


find_food(::Animal{<:Wolf}, w::World) = find_agent(Animal{Sheep}, w)
find_food(::Animal{<:Sheep}, w::World) = find_agent(Plant{Grass}, w)

function find_mate(a::Animal{A}, w::World) where A<:AnimalSpecies
    T = Animal{A}
    find_agent(T, w, x -> isa(x,T) && x.sex!=a.sex)
end

function reproduce!(a::Animal{A}, w::World) where A
    m = find_mate(a,w)
    if !isnothing(m)
        a.energy = a.energy / 2
        new_id = w.max_id + 1
        ŝ = Animal{A}(new_id, a.energy, a.Δenergy, a.reprprob, a.foodprob, randsex())
        w.agents[ŝ.id] = ŝ
        w.max_id = new_id
        return ŝ
    else
        nothing
    end
end


function agent_step!(a::Animal, w::World)
    a.energy -= 1
    if rand() <= a.foodprob
        dinner = find_food(a,w)
        eat!(a, dinner, w)
    end
    if a.energy <= 0
        kill_agent!(a,w)
        return
    end
    if rand() <= a.reprprob
        reproduce!(a,w)
    end
    return a
end
