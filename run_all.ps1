
# Run all Assignment 4 checks and save the output.

$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path "results" | Out-Null

function Run-And-Save {
    param(
        [string]$Label,
        [string]$OutputFile,
        [scriptblock]$Command
    )

    Write-Host "`n=== $Label ===" -ForegroundColor Cyan

    & $Command *> $OutputFile
    $exitCode = $LASTEXITCODE

    Get-Content $OutputFile

    if ($exitCode -ne 0) {
        throw "$Label failed. See $OutputFile"
    }

    Write-Host "Saved output to $OutputFile"
}

# 1. Go unit tests
Run-And-Save "Go unit tests" "results/go_tests.txt" {
    go test -v ./...
}

# 2. Go performance benchmark
Run-And-Save "Go benchmark" "results/go_benchmark.txt" {
    go test -bench=BenchmarkRegression -benchmem
}

# 3. Go program output
Run-And-Save "Go regression output" "results/go_output.txt" {
    go run .
}

# 4. Python regression
Run-And-Save "Python regression" "results/python_output.txt" {
    py python/regression.py
}

# 5. R regression
$rscript = "C:\Program Files\R\R-4.3.0\bin\Rscript.exe"

if (-not (Test-Path $rscript)) {
    throw "Rscript not found at $rscript. Update the path in run_all.ps1."
}

Run-And-Save "R regression" "results/r_output.txt" {
    & $rscript R/regression.R
}

# 6. Generate the Anscombe visualization
Run-And-Save "Anscombe visualization" "results/plot_output.txt" {
    & $rscript R/plot_anscombe.R
}

Write-Host "`nAll checks and scripts completed successfully." `
    -ForegroundColor Green
