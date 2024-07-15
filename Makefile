V110DIR := benchmark/v1.10
V111DIR := benchmark/v1.11

bench-scripts:
	julia --project=examples examples/ParametricSpeciesSexNTuple/bench.jl
	julia --project=examples examples/ParametricSpeciesSexDictUnion/bench.jl
	julia --project=examples examples/ParametricSpeciesNTuple/bench.jl
	julia --project=examples examples/ParametricSpeciesDictUnion/bench.jl

benchpkg:
	@if [ ! -d "$(V110DIR)" ]; then \
		echo "Directory $(V110DIR) does not exist. Creating..."; \
		mkdir -p $(V110DIR); \
	else \
		echo "Directory $(V110DIR) already exists."; \
	fi
	@if [ ! -d "$(V111DIR)" ]; then \
		echo "Directory $(V111DIR) does not exist. Creating..."; \
		mkdir -p $(V111DIR); \
	else \
		echo "Directory $(V111DIR) already exists."; \
	fi
	juliaup default 1.10
	julia --project=benchmark -e 'using Pkg; Pkg.update(); Pkg.status(); using InteractiveUtils; versioninfo()'
	~/.julia/bin/benchpkg -r dirty -s benchmark/benchmarks.jl -o benchmark/v1.10
	juliaup default 1.11
	julia --project=benchmark -e 'using Pkg; Pkg.update(); Pkg.status(); using InteractiveUtils; versioninfo()'
	~/.julia/bin/benchpkg -r dirty -s benchmark/benchmarks.jl -o benchmark/v1.11

benchpkgtable:
	~/.julia/bin/benchpkgtable -i benchmark/v1.10 -r dirty > benchmark/v1.10.md
	~/.julia/bin/benchpkgtable -i benchmark/v1.11 -r dirty > benchmark/v1.11.md
	bash benchmark/benchmarktable.sh -n 44 benchmark/v1.10.md benchmark/v1.11.md
