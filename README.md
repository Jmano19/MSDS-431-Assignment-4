# Anscombe Quartet: Regression Performance Comparison

## Overview

This project compares simple linear regression implementations in Go, Python, and R using Anscombe's Quartet. The goal is to evaluate correctness, execution performance, and memory-related metrics while considering the suitability of each language for a technology startup.

Anscombe's Quartet consists of four datasets, each containing 11 observations. Although the datasets have similar summary statistics and fitted regression lines, their distributions differ significantly. This makes them useful for demonstrating both the importance of regression analysis and the limitations of evaluating data using numerical summaries alone.

## Implementations

- **Go:** Uses `github.com/montanaflynn/stats` for linear regression.
- **Python:** Uses Pandas for dataset organization and Statsmodels `OLS` for regression.
- **R:** Uses the built-in `lm()` function for linear regression.

Each implementation processes all four datasets and reports the estimated intercept and slope. The results agree to six decimal places across all three languages.

## Benchmark Environment

| Component | Version or specification |
|---|---|
| Operating system | Windows |
| CPU | AMD Ryzen 7 5800X 8-Core Processor |
| Go | 1.27.1 (`windows/amd64`) |
| Python | 3.11.3 |
| Statsmodels | 0.15.0 |
| Pandas | 3.0.6 |
| R | 4.3.0 |
| Go regression library | `github.com/montanaflynn/stats` v0.13.0 |

## Regression Results

The following table shows the estimated coefficients for each dataset. Values are rounded to six decimal places.

| Dataset | Intercept | Slope |
|---|---:|---:|
| I | 3.000091 | 0.500091 |
| II | 3.000909 | 0.500000 |
| III | 3.002455 | 0.499727 |
| IV | 3.001727 | 0.499909 |

All three implementations produced matching coefficient estimates to the displayed precision.

## Data Visualization: Anscombe's Quartet

The project generates a 2×2 scatterplot of Anscombe's Quartet with a fitted linear regression line for each dataset. The visualization complements the numerical regression results by showing how different data distributions can produce similar regression coefficients.
The four plots highlight different analytical challenges: an approximately linear relationship, a nonlinear pattern, an influential outlier, and a high-leverage observation.
The visualization is generated using R's built-in anscombe dataset and base plotting functions. No additional R plotting package is required.

![Ansbombe Quartet](results\anscombe_quartet.png)

## Performance Results

| Metric | Go | Python | R |
|---|---:|---:|---:|
| Regression calls | Varies by benchmark iteration | 40,000 | 40,000 |
| Reported elapsed time | 616.9 ns per four-dataset operation | 29.004 s | 14.790 s |
| Average time per regression | Approximately 0.154 µs | 725.099 µs | 369.750 µs |
| Memory / allocation result | 2,496 B/op; 16 allocations/op | 8.80 MB sampled working set* | 6.82 MB sampled working set |
| Coefficient agreement | Yes | Yes | Yes |

\*The Python memory measurement may reflect the Python launcher process rather than the actual Python interpreter. It is therefore provisional and should not be treated as a reliable measurement of Python's memory consumption.

### Benchmark Methodology

**Go:** The Go testing benchmark measures repeated regression operations across all four datasets. Dataset setup is excluded from the timed section using `b.ResetTimer()`. The reported result is 616.9 nanoseconds per four-dataset operation, equivalent to approximately 154.2 nanoseconds per dataset regression. Go also reports bytes and allocations per benchmark operation.

**Python:** The script uses `time.perf_counter()` to measure 10,000 iterations across the four datasets, totaling 40,000 regression calls. The reported average is approximately 725.099 microseconds per regression.

**R:** The script uses `system.time()` to measure 10,000 iterations across the four datasets, totaling 40,000 regression calls. The reported average is approximately 369.750 microseconds per regression.

The Python and R timing measurements exclude initial script execution and setup outside the timed loop, but each regression call still incurs the overhead of its respective language and statistical library. The Go benchmark uses a different benchmarking framework and implementation.

### Interpreting the Results

R completed the measured workload in approximately half the elapsed time reported for Python. Go reported very low per-operation latency and low allocation volume for its implementation.

These figures are specific to this workload and implementation. They should not be interpreted as a definitive ranking of the languages themselves. In particular, Go's allocation-per-operation metric is not directly comparable to Python's and R's sampled process working-set measurements.

## Findings

The experiment demonstrates three main findings:

1. **Correctness:** All three implementations produce matching regression coefficients to six decimal places.
2. **Performance:** The measured R workload completed faster than the Python workload, while the Go benchmark reported very low latency for its implementation. Different libraries, execution models, and benchmark methods limit direct comparisons.
3. **Data interpretation:** Similar regression coefficients do not mean datasets have the same distribution or contain the same outliers. Anscombe's Quartet illustrates why visualization and diagnostic analysis are important alongside regression results.

Because each dataset contains only 11 observations, the experiment does not establish how these implementations would perform on large datasets, concurrent workloads, or production-scale analytical systems.

## Management Recommendation

Go is a strong candidate for backend services, distributed systems, and performance-sensitive infrastructure. Its compiled deployment model, concurrency support, and performance characteristics can be useful when a startup wants consistent engineering practices across backend teams.

However, this experiment does not justify requiring Go for every statistical or research task. Python and R have mature statistical ecosystems that can make experimentation, model diagnostics, and data analysis more productive.

A practical strategy is to standardize Go for appropriate backend and distributed-service workloads while permitting Python or R where their analytical libraries provide clear advantages. Well-defined APIs, data pipelines, and interfaces can allow teams to collaborate without requiring every task to use the same language.

## Project Structure

```text
.
├── main.go
├── regression.go
├── regression_test.go
├── benchmark_test.go
├── go.mod
├── go.sum
├── anscombe.exe
├── python/
│   └── regression.py
├── R/
│   └── regression.R
├── results/
└── measure_memory.ps1
```

The compiled executable is generated by the Go build command. The `results/` directory can contain saved benchmark outputs if required for submission.

## How to Run

### Go

Run the program:

```powershell
go run .
```

Build and execute the standalone program:

```powershell
go build -o anscombe.exe .
.\anscombe.exe
```

Run unit tests:

```powershell
go test -v ./...
```

Run the performance benchmark:

```powershell
go test -bench=BenchmarkRegression -benchmem
```

### Python

Install the required dependencies:

```powershell
py -m pip install pandas statsmodels
```

Run the regression script:

```powershell
py python/regression.py
```

### R

Run the regression script if `Rscript` is on your PATH:

```powershell
Rscript R/regression.R
```

If `Rscript` is not on your PATH, use its full installation path. For example:

```powershell
& "C:\Program Files\R\R-4.3.0\bin\Rscript.exe" R/regression.R
```

### Memory Measurement

Run the PowerShell memory measurement script:

```powershell
powershell -ExecutionPolicy Bypass -File .\measure_memory.ps1
```

This script samples process working-set memory. Sampling can miss short-lived peaks, and the Python result should be treated as provisional until the script measures the actual Python interpreter process.

## Limitations

- Each regression uses only 11 observations.
- The benchmark methods and implementations differ across languages.
- Go allocation metrics and sampled process memory are not equivalent measurements.
- The Python memory result may reflect the launcher rather than the interpreter.
- Timing and memory results can vary with software versions, hardware, system load, and measurement overhead.
- The experiment does not evaluate large datasets, parallel execution, model diagnostics, or broader statistical functionality.
- The results describe these particular implementations and do not establish a universal performance ranking for Go, Python, or R.
