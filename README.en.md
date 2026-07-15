# Sorting Sins

A multi-language demo project that demonstrates the same "sorting sin" — using a non-deterministic comparator (random comparison function) in sorting.

## Observations

Multiple languages implement the same logic: generate array `[0, 1, 2, ..., N-1]`, then sort it with a random comparator. First tested at N=100, then scaled to one million (N=1,000,000). Results:

| Language                              | Behavior                                     |
| ------------------------------------- | -------------------------------------------- |
| **C++(Clang)**                        | shuffled                                     |
| **Python**                            | shuffled                                     |
| **JavaScript (Node.js / Bun / Deno)** | shuffled                                     |
| **Go**                                | shuffled                                     |
| **Java**                              | shuffled at N=100, **throws** at N=1,000,000 |
| **C#**                                | shuffled at N=100, **throws** at N=1,000,000 |
| **Rust**                              | **panic** (both scales)                      |

## Conclusion

- **C++, Python, JavaScript, Go** — no runtime checking at either N=100 or N=1,000,000. The sort implementations silently return a randomly shuffled result.
- **Java, C#** — pass silently at N=100, but when scaled to N=1,000,000 the sorting algorithm (Java TimSort, C# `Array.Sort`) detects the invalid comparator and **throws an exception**. This demonstrates that detection capability is data-size-dependent; small inputs may not trigger the internal consistency checks.
- **Rust** — the code compiles without error, but the standard library's sort implementation detects comparator inconsistency at runtime and **panics** at both N=100 and N=1,000,000 (since v1.81.0).

The author plans to conduct further statistical analysis on the non-panic languages in future work, to gain deeper insight into how random comparators behave across different sorting algorithm implementations and to identify any potential biases.

## Rust Sort Evolution

I initially only tested the latest version of Rust. In a discussion with a friend ([LaunchPad](https://github.com/LaunchPad001)), I learned that earlier versions (e.g., 1.75.0) do not panic — they output a seemingly random permutation instead.

Later, another friend [lfcypo](https://github.com/lfcypo) provided the exact version history and specific change explanation.

The panic behavior of Rust's sort in this demo is version-dependent, with two key PRs shaping the current behavior:

| PR                                                       | PR Summary                                                                                                                                                                                                                                                       | Merged       | Released    |
| -------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | ----------- |
| [#124032](https://github.com/rust-lang/rust/pull/124032) | Replace sort implementations — introduced **driftsort** (`slice::sort`) and **ipnsort** (`slice::sort_unstable`). The new implementations actively detect **strict weak ordering** violations and panic, whereas the old Timsort/pdqsort did not reliably do so. | Jun 21, 2024 | Rust 1.81.0 |
| [#128273](https://github.com/rust-lang/rust/pull/128273) | Improve Ord violation help — refined the panic message to `user-provided comparison function does not correctly implement a total order` and improved documentation.                                                                                             | Aug 11, 2024 | Rust 1.81.0 |

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
.\build.ps1 -Lang java   # build Java only
.\build.ps1 -Lang rust   # build Rust only
.\build.ps1 -Lang csharp # build C# only
```

> All languages accept an optional `N` argument (data size, default 100). E.g., `node ./js/main.js 1000000`.

### JavaScript

```shell
node ./js/main.js        # Node.js (default N=100)
node ./js/main.js 1000000
bun ./js/main.js         # Bun.js
deno ./js/main.js        # Deno.js
```

### Java

```shell
java ./java/Main.java            # Java 11+, default N=100
java ./java/Main.java 1000000
```

### Python

```shell
python ./python/main.py          # default N=100
python ./python/main.py 1000000
```

### Golang

```shell
go run ./go/main.go              # default N=100
go run ./go/main.go 1000000
# or build
go build -o ./dist/go ./go/main.go
```

### C++

```shell
clang++ ./cpp/main.cpp -o ./dist/cpp
./dist/cpp                       # default N=100
./dist/cpp 1000000
```

### C#

```shell
dotnet run --project ./csharp            # default N=100
dotnet run --project ./csharp -- 1000000
```

### Rust

```shell
# Latest Rust (≥1.81.0) — found to panic in testing
cargo run --manifest-path ./rust/Cargo.toml              # default N=100
cargo run --manifest-path ./rust/Cargo.toml -- 1000000

# Rust 1.80.0 — no panic found in limited testing
cargo +1.80.0 run --manifest-path ./rust/Cargo.toml

# or build
cargo build --release --manifest-path ./rust/Cargo.toml
./rust/target/release/sorting-sins                       # default N=100
./rust/target/release/sorting-sins 1000000
```
