# Sorting Sins

一个多语言演示项目，展示了同一种「排序原罪」——在排序中使用非确定性的比较器（随机比较函数）。

## 现象

多种语言实现了相同的逻辑：生成数组 `[0, 1, 2, ..., N-1]`，然后用一个随机比较函数对其进行排序。先以 N=100 测试，随后将数据量提升至百万级（N=1,000,000）再次测试。结果如下：

| 语言                                  | 行为                                   |
| ------------------------------------- | -------------------------------------- |
| **C++(Clang)**                        | （疑似）随机排列                       |
| **Python**                            | （疑似）随机排列                       |
| **JavaScript (Node.js / Bun / Deno)** | （疑似）随机排列                       |
| **Go**                                | （疑似）随机排列                       |
| **Java**                              | N=100 随机排列，N=1,000,000 **抛异常** |
| **C#**                                | N=100 随机排列，N=1,000,000 **抛异常** |
| **Rust(latest)**                      | **panic**                              |
| **Rust(v1.80.0)**                     | （疑似）随机排列                       |

## 结论

- **C++、Python、JavaScript、Go** —— 无论 N=100 还是 N=1,000,000，这些语言的 sort 实现均未进行运行期检查，静默返回被随机打乱的结果。
- **Java、C#** —— 在 N=100 时静默通过，数据量提升至 N=1,000,000 后，排序算法（Java TimSort、C# `Array.Sort`）检测到比较器违反契约，直接 **抛异常**。这说明检测能力与数据规模相关，小数据量下可能无法触发检查逻辑。
- **Rust** —— 代码可以正常通过编译，但标准库的排序实现在运行期主动检测到比较器违反 total order 约束，直接 **panic**。无论 N=100 还是 N=1,000,000 均稳定触发。

作者计划在未来对非 panic 语言的输出结果进行更深入的统计分析，以进一步探究随机比较器在不同排序算法实现中的实际行为特征与潜在偏差。

## Rust 排序演进

我一开始只测试了 Rust 最新版本，但是在与朋友（[LaunchPad](https://github.com/LaunchPad001)）的讨论中发现，Rust 在早期版本（如 1.75.0）并不会 panic，而是输出一个看似随机的排列。

后续朋友 [lfcypo](https://github.com/lfcypo) 提供了历史版本最终和具体变更解释。

本演示中 Rust 的 panic 行为取决于版本，两个关键 PR 塑造了当前行为：

| PR                                                       | PR 信息摘要                                                                                                                                                                            | 合并日期   | 发布版本    |
| -------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | ----------- |
| [#124032](https://github.com/rust-lang/rust/pull/124032) | 替换排序实现——引入 **driftsort**（`slice::sort`）和 **ipnsort**（`slice::sort_unstable`）。新实现能主动检测 **strict weak ordering** 违例并 panic，旧版 Timsort/pdqsort 无法可靠检测。 | 2024-06-21 | Rust 1.81.0 |
| [#128273](https://github.com/rust-lang/rust/pull/128273) | 改进 Ord 违例帮助信息——将 panic 信息优化为 `user-provided comparison function does not correctly implement a total order`，并完善文档。                                                | 2024-08-11 | Rust 1.81.0 |

**变更说明**：新实现增加了运行时的一致性检查，对于许多违反 total order 的比较器会主动 panic，而旧版排序实现通常不会进行此类检测。

**1.81.0 之前**（如 1.80.0）：在有限的测试中，传入非确定性比较器时，排序静默输出看似随机的排列。

**1.81.0 起**：排序实现能以高概率检测到比较器不一致并 panic。已通过 `cargo +1.80.0 run` 与 `cargo run`（稳定 panic）对比验证。

## 运行方式

### 构建所有

```shell
.\build.ps1              # 构建当前系统所有语言版本
.\build.ps1 -Lang js     # 仅构建 JavaScript
.\build.ps1 -Lang python # 仅构建 Python
.\build.ps1 -Lang cpp    # 仅构建 C++
.\build.ps1 -Lang go     # 仅构建 Go
.\build.ps1 -Lang java   # 仅构建 Java
.\build.ps1 -Lang rust   # 仅构建 Rust
.\build.ps1 -Lang csharp # 仅构建 C#
```

> 所有语言均接受可选参数 `N`（数据量，默认 100）。例如 `node ./js/main.js 1000000`。

### JavaScript

```shell
node ./js/main.js        # Node.js（默认 N=100）
node ./js/main.js 1000000
bun ./js/main.js         # Bun.js
deno ./js/main.js        # Deno.js
```

### Java

```shell
java ./java/Main.java            # Java 11+，默认 N=100
java ./java/Main.java 1000000
```

### Python

```shell
python ./python/main.py          # 默认 N=100
python ./python/main.py 1000000
```

### Golang

```shell
go run ./go/main.go              # 默认 N=100
go run ./go/main.go 1000000
# 或编译
go build -o ./dist/go ./go/main.go
```

### C++

```shell
clang++ ./cpp/main.cpp -o ./dist/cpp
./dist/cpp                       # 默认 N=100
./dist/cpp 1000000
```

### C#

```shell
dotnet run --project ./csharp            # 默认 N=100
dotnet run --project ./csharp -- 1000000
```

### Rust

```shell
# 最新版 Rust（≥1.81.0）— 在测试中发现会 panic
cargo run --manifest-path ./rust/Cargo.toml              # 默认 N=100
cargo run --manifest-path ./rust/Cargo.toml -- 1000000

# Rust 1.80.0 — 在有限的测试中没有发现 panic
cargo +1.80.0 run --manifest-path ./rust/Cargo.toml

# 或编译
cargo build --release --manifest-path ./rust/Cargo.toml
./rust/target/release/sorting-sins                       # 默认 N=100
./rust/target/release/sorting-sins 1000000
```
