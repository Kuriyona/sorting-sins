
# Sorting Sins

A multi-language demo project that demonstrates the same "sorting sin" — using a non-deterministic comparator (random comparison function) in sorting.

## Observations

Eight languages implement the same logic: generate array `[0, 1, 2, ..., 99]`, then sort it with a random comparator. Each language was run 3 times:

| Language | Behavior |
|----------|----------|
| **C++** | apparently shuffled |
| **Python** | apparently shuffled |
| **JavaScript (Node.js)** | apparently shuffled |
| **JavaScript (Bun)** | apparently shuffled |
| **JavaScript (Deno)** | apparently shuffled |
| **Dart** | apparently shuffled |
| **Java** | apparently shuffled |
| **Go** | apparently shuffled |
| **C#** | apparently shuffled |
| **Rust (latest)** | **panic** |
| **Rust (v1.80.0)** | apparently shuffled |

## Conclusion

- **C++, Python, JavaScript, Dart, Java, Go, C#** — these languages' sort implementations perform no runtime checking when the comparator violates the sorting contract (non-reflexive, non-transitive, inconsistent). They silently produce output that appears to be a random permutation, though this has not been rigorously verified through statistical testing.
- **Rust (latest)** — the code compiles without error, but the standard library's sort implementation (since v1.81.0) detects the comparator is not a total order at runtime and **panics**. Among the languages tested in this repository, Rust is the only one that performs a runtime safety check against this undefined behavior.
- **Rust (v1.80.0)** — the older sort implementations did not panic within the limited scope of this project's testing, and instead output what appears to be a random permutation.

The author plans to conduct further statistical analysis on the non-panic languages in future work, to gain deeper insight into how random comparators behave across different sorting algorithm implementations and to identify any potential biases.

## Rust Sort Evolution

I initially only tested the latest version of Rust. In a discussion with a friend ([LaunchPad](https://github.com/LaunchPad001)), I learned that earlier versions (e.g., 1.75.0) do not panic — they output a seemingly random permutation instead.

Later, another friend [lfcypo](https://github.com/lfcypo) provided the exact version history and specific change explanation.

The panic behavior of Rust's sort in this demo is version-dependent, with two key PRs shaping the current behavior:

| PR | PR Summary | Merged | Released |
|----|-------------|--------|----------|
| [#124032](https://github.com/rust-lang/rust/pull/124032) | Replace sort implementations — introduced **driftsort** (`slice::sort`) and **ipnsort** (`slice::sort_unstable`). The new implementations actively detect **strict weak ordering** violations and panic, whereas the old Timsort/pdqsort did not reliably do so. | Jun 21, 2024 | Rust 1.81.0 |
| [#128273](https://github.com/rust-lang/rust/pull/128273) | Improve Ord violation help — refined the panic message to `user-provided comparison function does not correctly implement a total order` and improved documentation. | Aug 11, 2024 | Rust 1.81.0 |

**Change description**: The new implementations added runtime consistency checks; for many comparators that violate total order, they will proactively panic, whereas the old sort implementations typically did not perform such checks.

**Before 1.81.0** (e.g., 1.80.0): within the limited scope of testing, passing a non-deterministic comparator resulted in the sort silently producing a random-looking permutation.

**Since 1.81.0**: the sort implementations detect comparator inconsistencies with high probability and panic. Verified by running with `cargo +1.80.0 run` (no panic) vs `cargo run` (consistently panics).

## How to Run

### Build All

```shell
.\build.ps1              # build all languages for host OS
.\build.ps1 -Lang js     # build JavaScript only
.\build.ps1 -Lang python # build Python only
.\build.ps1 -Lang cpp    # build C++ only
.\build.ps1 -Lang go     # build Go only
.\build.ps1 -Lang dart   # build Dart only
.\build.ps1 -Lang java   # build Java only
.\build.ps1 -Lang rust   # build Rust only
.\build.ps1 -Lang csharp # build C# only
```

### JavaScript

```shell
node ./js/main.js  # Node.js
bun ./js/main.js   # Bun.js
deno ./js/main.js  # Deno.js
```

### Dart

```shell
dart run ./dart/main.dart
```

### Java

```shell
java ./java/Main.java       # Java 11+ (source-file mode)
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
# Latest Rust (≥1.81.0) — found to panic in testing
cargo run --manifest-path ./rust/Cargo.toml

# Rust 1.80.0 — no panic found in limited testing
cargo +1.80.0 run --manifest-path ./rust/Cargo.toml

# or build
cargo build --release --manifest-path ./rust/Cargo.toml
./rust/target/release/sorting-sins
```
