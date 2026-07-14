
# Sorting Sins

一个多语言演示项目，展示了同一种「排序原罪」——在排序中使用非确定性的比较器（随机比较函数）。

## 现象

八种语言实现了相同的逻辑：生成数组 `[0, 1, 2, ..., 99]`，然后用一个随机比较函数对其进行排序。每种语言运行 3 次的结果如下：

| 语言 | 行为 |
|------|---------|
| **C++** | （疑似）随机排列 |
| **Python** | （疑似）随机排列 |
| **JavaScript (Node.js)** | （疑似）随机排列 |
| **JavaScript (Bun)** | （疑似）随机排列 |
| **JavaScript (Deno)** | （疑似）随机排列 |
| **Dart** | （疑似）随机排列 |
| **Java** | （疑似）随机排列 |
| **Go** | （疑似）随机排列 |
| **C#** | （疑似）随机排列 |
| **Rust** | **panic** |

## 结论

- **C++、Python、JavaScript、Dart、Java、Go、C#** —— 尽管比较器违反了排序契约（非自反、非传递、不一致），这些语言的 sort 实现未进行运行期检查，静默返回结果。从输出形态观察，每次运行的结果都疑似随机排列，但未经严格的统计检验确认。
- **Rust** —— 代码可以正常通过编译，但标准库的排序实现在运行期主动检测到比较器违反 total order 约束，直接 **panic** 并报错：`user-provided comparison function does not correctly implement a total order`。Rust 是唯一在运行期对这种未定义行为进行安全检查的语言。

作者计划在未来对非 panic 语言的输出结果进行更深入的统计分析，以进一步探究随机比较器在不同排序算法实现中的实际行为特征与潜在偏差。

## 运行方式

### 构建所有

```shell
.\build.ps1              # 构建当前系统所有语言版本
.\build.ps1 -Lang js     # 仅构建 JavaScript
.\build.ps1 -Lang python # 仅构建 Python
.\build.ps1 -Lang cpp    # 仅构建 C++
.\build.ps1 -Lang go     # 仅构建 Go
.\build.ps1 -Lang dart   # 仅构建 Dart
.\build.ps1 -Lang java   # 仅构建 Java
.\build.ps1 -Lang rust   # 仅构建 Rust
.\build.ps1 -Lang csharp # 仅构建 C#
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
# 或编译
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
