
# Sorting Sins

一个多语言演示项目，展示了同一种「排序原罪」——在排序中使用非确定性的比较器（随机比较函数）。

## 现象

六种语言实现了相同的逻辑：生成数组 `[0, 1, 2, ..., 99]`，然后用一个随机比较函数对其进行排序。每种语言运行 3 次的结果如下：

| 语言 | 行为 |
|------|---------|
| **C++** | 随机排列 |
| **Python** | 随机排列 |
| **JavaScript (Node.js)** | 随机排列 |
| **JavaScript (Bun)** | 随机排列 |
| **Go** | 随机排列 |
| **C#** | 随机排列 |
| **Rust** | **panic** |

## 结论

- **C++、Python、JavaScript、Go、C#** —— 尽管比较器违反了排序算法的契约（非自反、非传递、不一致），这些语言的 sort 实现仍然「容忍」了错误，默默地输出一个看似随机排列的结果，且从不报错。
- **Rust** —— 在标准库的排序实现内部主动检测到比较器违反了 total order 约束，直接 **panic** 并报错：`user-provided comparison function does not correctly implement a total order`。Rust 是唯一一个在运行期对这种未定义行为进行安全检查的语言。

这反映了各语言设计哲学的不同：C++/Python/JS/Go/C# 倾向于信任开发者并尽可能返回结果（哪怕结果是错的），而 Rust 则在检测到契约被违反时立即终止程序，帮助开发者尽早发现问题。

## 运行方式

### 构建所有

```shell
.\build.ps1              # 构建当前系统所有语言版本
.\build.ps1 -Lang js     # 仅构建 JavaScript
.\build.ps1 -Lang python # 仅构建 Python
.\build.ps1 -Lang cpp    # 仅构建 C++
.\build.ps1 -Lang go     # 仅构建 Go
.\build.ps1 -Lang rust   # 仅构建 Rust
.\build.ps1 -Lang csharp # 仅构建 C#
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
