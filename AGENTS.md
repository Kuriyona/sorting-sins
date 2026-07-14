# Sorting Sins

Multi-language demo showing what happens when sort comparators are non-deterministic (random). Rust panics; everyone else silently shuffles.

## Structure

Each language is a **single-file standalone program** (except Rust/C# which have minimal manifests):

| Language  | Entrypoint              | Run command                                    |
|-----------|-------------------------|------------------------------------------------|
| JavaScript| `js/main.js`            | `node ./js/main.js` (also bun, deno)           |
| Python    | `python/main.py`        | `python ./python/main.py`                      |
| C++       | `cpp/main.cpp`          | `clang++ ./cpp/main.cpp -o ./dist/cpp && ./dist/cpp` |
| Go        | `go/main.go`            | `go run ./go/main.go`                          |
| C#        | `csharp/Program.cs`     | `dotnet run --project ./csharp`                |
| Rust      | `rust/src/main.rs`      | `cargo run --manifest-path ./rust/Cargo.toml`  |

## Build

Only on Windows via PowerShell:

```
.\build.ps1              # builds all
.\build.ps1 -Lang rust   # single language
```

Output lands in `dist/` (gitignored).

## Adding a new language

1. **Write code** — single-file program under `{lang}/main.{ext}` (or minimal manifest if needed). Logic: generate `[0..99]`, sort with random comparator, print.
2. **Test** — run it directly to verify no errors and output is shuffled.
3. **Build** — add a `-Lang` case to `build.ps1` following existing conventions (copy or compile, name as `sorting-sins-{lang}-{os}{ext}`).
4. **Document** — add run command to both `README.md` and `README.en.md` (table + individual section).
5. **Conclude** — run the built artifact 3+ times, then update the behavior table and conclusion text in both READMEs.

## Known quirks

- C# targets **net10.0** with `PublishAot=true`
- Rust uses **rand 0.8** (older, via `Cargo.toml`)
- No tests, no linters, no formatters, no CI, no typecheckers exist anywhere in the repo
- `dist/`, `rust/target/`, `csharp/bin/`, `csharp/obj/` are gitignored
