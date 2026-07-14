param(
    [string]$Lang = "all"
)

$Root = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Dist = Join-Path $Root "dist"

if (-not (Test-Path $Dist)) {
    New-Item -ItemType Directory -Path $Dist | Out-Null
}

$HostOS = if ($env:OS -match "Windows") { "windows" } else { (uname -s).ToLower() }

function Get-Ext {
    param([string]$os)
    if ($os -eq "windows") { return ".exe" }
    return ""
}

switch ($Lang) {
    "js" {
        $name = "sorting-sins-js-$HostOS.js"
        Write-Host "[JS] Copying to dist\$name..."
        Copy-Item -Path (Join-Path $Root "js\main.js") -Destination (Join-Path $Dist $name)
    }
    "python" {
        $name = "sorting-sins-py-$HostOS.py"
        Write-Host "[Python] Copying to dist\$name..."
        Copy-Item -Path (Join-Path $Root "python\main.py") -Destination (Join-Path $Dist $name)
    }
    "cpp" {
        $ext = Get-Ext -os $HostOS
        $name = "sorting-sins-cpp-$HostOS$ext"
        Write-Host "[C++] Compiling $name..."
        clang++ (Join-Path $Root "cpp\main.cpp") -o (Join-Path $Dist $name)
    }
    "go" {
        $ext = Get-Ext -os $HostOS
        $name = "sorting-sins-go-$HostOS$ext"
        Write-Host "[Go] Compiling $name..."
        $env:GOOS = $HostOS
        $env:GOARCH = "amd64"
        go build -o (Join-Path $Dist $name) (Join-Path $Root "go\main.go")
        Remove-Item Env:\GOOS, Env:\GOARCH -ErrorAction SilentlyContinue
    }
    "rust" {
        $target = switch ($HostOS) {
            "windows" { "x86_64-pc-windows-msvc" }
            "linux"   { "x86_64-unknown-linux-gnu" }
            "darwin"  { "x86_64-apple-darwin" }
        }
        $installed = rustup target list --installed 2>$null
        if ($installed -notcontains $target) {
            Write-Host "[Rust] Skipping $HostOS (target '$target' not installed)"
        } else {
            $ext = Get-Ext -os $HostOS
            $name = "sorting-sins-rust-$HostOS$ext"
            Write-Host "[Rust] Compiling $name (target: $target)..."
            cargo build --release --target $target --manifest-path (Join-Path $Root "rust\Cargo.toml") 2>&1 | Out-Null
            Copy-Item -Path (Join-Path $Root "rust\target\$target\release\sorting-sins.exe") -Destination (Join-Path $Dist $name) -ErrorAction SilentlyContinue
            Copy-Item -Path (Join-Path $Root "rust\target\$target\release\sorting-sins$ext") -Destination (Join-Path $Dist $name) -ErrorAction SilentlyContinue
        }
    }
    "csharp" {
        $rid = switch ($HostOS) {
            "windows" { "win-x64" }
            "linux"   { "linux-x64" }
            "darwin"  { "osx-x64" }
        }
        $ext = Get-Ext -os $HostOS
        $name = "sorting-sins-csharp-$HostOS$ext"
        Write-Host "[C#] Compiling $name..."
        dotnet publish (Join-Path $Root "csharp") -c Release -o (Join-Path $Dist "temp") -r $rid --self-contained 2>&1 | Out-Null
        Copy-Item -Path (Join-Path $Dist "temp\sorting-sins$ext") -Destination (Join-Path $Dist $name)
        Remove-Item -Recurse -Force (Join-Path $Dist "temp")
    }
    "all" {
        & $MyInvocation.MyCommand.Path -Lang "js"
        & $MyInvocation.MyCommand.Path -Lang "python"
        & $MyInvocation.MyCommand.Path -Lang "cpp"
        & $MyInvocation.MyCommand.Path -Lang "go"
        & $MyInvocation.MyCommand.Path -Lang "rust"
        & $MyInvocation.MyCommand.Path -Lang "csharp"
    }
    default {
        Write-Host "Usage: build.ps1 [-Lang <js|python|cpp|go|rust|csharp|all>]"
    }
}
