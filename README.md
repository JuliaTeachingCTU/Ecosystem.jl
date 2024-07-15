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
| ParametricSpeciesDictUnion/find_food    | 0.215 ± 0.012 ms   | 0.215 ± 0.0064 ms  |
| ParametricSpeciesDictUnion/reproduce    | 0.569 ± 0.36 ms    | 0.536 ± 0.38 ms    |
| ParametricSpeciesNTtuple/find_food      | 14.9 ± 2.8 μs      | 14.8 ± 4.3 μs      |
| ParametricSpeciesNTtuple/reproduce      | 0.103 ± 0.1 ms     | 0.0924 ± 0.11 ms   |
| ParametricSpeciesSexDictUnion/find_food | 0.208 ± 0.012 ms   | 0.22 ± 0.0075 ms   |
| ParametricSpeciesSexDictUnion/reproduce | 0.47 ± 0.26 ms     | 0.526 ± 0.3 ms     |
| ParametricSpeciesSexNTuple/find_food    | 12 ± 8.5 μs        | 15.5 ± 4.3 μs      |
| ParametricSpeciesSexNTuple/reproduce    | 0.083 ± 0.041 μs   | 0.084 ± 0.042 μs   |
| ParametricSpeciesSexSumType/find_food   | 0.0669 ± 0.0085 ms | 0.0575 ± 0.0024 ms |
| ParametricSpeciesSexSumType/reproduce   | 0.0907 ± 0.056 ms  | 0.0939 ± 0.057 ms  |
| time_to_load                            | 0.0378 ± 0.0047 s  | 0.052 ± 0.0017 s   |



To produce the table above:

```bash
make benchpkg
make benchpkgtable
```
