
# Sorting Sins

A multi-language demo project that demonstrates the same "sorting sin" — using a non-deterministic comparator (random comparison function) in sorting.

## Observations

Six languages implement the same logic: generate array `[0, 1, 2, ..., 99]`, then sort it with a random comparator. Each language was run 3 times:

| Language | Behavior |
|----------|----------|
| **C++** | shuffled |
| **Python** | shuffled |
| **JavaScript (Node.js)** | shuffled |
| **JavaScript (Bun)** | shuffled |
| **JavaScript (Deno)** | shuffled |
| **Go** | shuffled |
| **C#** | shuffled |
| **Rust** | **panic** |

## Conclusion

- **C++, Python, JavaScript, Go, C#** — despite the comparator violating the sorting contract (non-reflexive, non-transitive, inconsistent), these languages' sort implementations silently tolerate the error and produce a seemingly random permutation, never reporting any issue.
- **Rust** — the standard library's sort implementation actively detects that the comparator violates the total order constraint and **panics** with: `user-provided comparison function does not correctly implement a total order`. Rust is the only language that performs a safety check against this undefined behavior at runtime.

This reflects different design philosophies: C++/Python/JS/Go/C# trust the developer and try to return a result (even if wrong), while Rust terminates the program when a contract is violated, helping developers catch bugs early.

## How to Run

### Build All

```shell
.\build.ps1              # build all languages for host OS
.\build.ps1 -Lang js     # build JavaScript only
.\build.ps1 -Lang python # build Python only
.\build.ps1 -Lang cpp    # build C++ only
.\build.ps1 -Lang go     # build Go only
.\build.ps1 -Lang rust   # build Rust only
.\build.ps1 -Lang csharp # build C# only
```

### JavaScript

```shell
node ./js/main.js  # Node.js
bun ./js/main.js   # Bun.js
deno ./js/main.js  # Deno.js
```

### Python

```shell
python ./python/main.py
```

### Golang

```shell
go run ./go/main.go
# or build
go build -o ./dist/go ./go/main.go
```

### C++

```shell
clang++ ./cpp/main.cpp -o ./dist/cpp
```

### C#

```shell
dotnet run --project ./csharp
# or build & run
dotnet run --project ./csharp -c Release
```

### Rust

```shell
cargo run --manifest-path ./rust/Cargo.toml
# or build
cargo build --release --manifest-path ./rust/Cargo.toml
./rust/target/release/sorting-sins
```
