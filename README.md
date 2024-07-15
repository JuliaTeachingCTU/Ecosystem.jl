# Ecosystem

This package contains a number (currently 5) alternative implementations of a
simple agent based simulation. The difference is mostly in the type signature of the `World`:

- `World{Dict{Int64, Union{Animal{🐑}, Plant{🌿}}}}` is a plain `Dict` of `Union`s.
- `World{Dict{Int64, Union{Animal{🐑, ♀}, Animal{🐑, ♂}, Plant{🌿}}}}` is a dict of unions with additional type parameter in the animal.
- `World{@NamedTuple{Sheep::Dict{Int64, Animal{🐑}}, Grass::Dict{Int64, Plant{🌿}}}}` is a tuple of dictionaries where the dictionaries have concrete types.
- `World{@NamedTuple{SheepFemale::Dict{Int64, Animal{🐑, ♀}}, SheepMale::Dict{Int64, Animal{🐑, ♂}}, Grass::Dict{Int64, Plant{🌿}}}}` - same as above just with `Animal{A,S}`.
- `World{Dict{Int64, Agent}}` where `Agent` is a `DynamicSumType`. Uses the animal with two type parameters `Animal{A,S}`.

The dict of union approach is the slowest, the named tuples are the fastest (by
far - note the units). DynamicSumTypes.jl are 3-5x faster than the dict of union
while not making the `World` type as complicated as it is with the named tuples.

## Benchmarks

|                                         | v1.10              | v1.11              |
|:----------------------------------------|:------------------:|:------------------:|
| ParametricSpeciesDictUnion/find_food    | 0.242 ± 0.011 ms   | 0.215 ± 0.01 ms    |
| ParametricSpeciesDictUnion/reproduce    | 0.562 ± 0.32 ms    | 0.568 ± 0.36 ms    |
| ParametricSpeciesSexSumType/find_food   | 0.0502 ± 0.0084 ms | 0.0525 ± 0.0023 ms |
| ParametricSpeciesSexSumType/reproduce   | 0.116 ± 0.078 ms   | 0.124 ± 0.081 ms   |
|                                         |                    |                    |
| ParametricSpeciesSexDictUnion/find_food | 0.206 ± 0.011 ms   | 0.214 ± 0.0057 ms  |
| ParametricSpeciesSexDictUnion/reproduce | 0.487 ± 0.28 ms    | 0.457 ± 0.29 ms    |
|                                         |                    |                    |
| ParametricSpeciesNTtuple/find_food      | 2.75 ± 2.8 μs      | 2.79 ± 2.9 μs      |
| ParametricSpeciesNTtuple/reproduce      | 0.103 ± 0.099 ms   | 0.0938 ± 0.1 ms    |
| ParametricSpeciesSexNTuple/find_food    | 2.75 ± 2.8 μs      | 2.71 ± 2.8 μs      |
| ParametricSpeciesSexNTuple/reproduce    | 0.042 ± 0.001 μs   | 0.042 ± 0.001 μs   |



To produce the table above:

```bash
make benchpkg
make benchpkgtable
```
