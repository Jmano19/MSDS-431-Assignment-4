
import time
import pandas as pd
import statsmodels.api as sm

anscombe = pd.DataFrame({
    "x1": [10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5],
    "x2": [10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5],
    "x3": [10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5],
    "x4": [8, 8, 8, 8, 8, 8, 8, 19, 8, 8, 8],
    "y1": [8.04, 6.95, 7.58, 8.81, 8.33, 9.96, 7.24, 4.26, 10.84, 4.82, 5.68],
    "y2": [9.14, 8.14, 8.74, 8.77, 9.26, 8.10, 6.13, 3.10, 9.13, 7.26, 4.74],
    "y3": [7.46, 6.77, 12.74, 7.11, 7.81, 8.84, 6.08, 5.39, 8.15, 6.42, 5.73],
    "y4": [6.58, 5.76, 7.71, 8.84, 8.47, 7.04, 5.25, 12.50, 5.56, 7.91, 6.89],
})


def linear_regression(x, y):
    model = sm.OLS(y, sm.add_constant(x)).fit()
    return float(model.params.iloc[0]), float(model.params.iloc[1])


def main():
    print("Anscombe Quartet: Python Statsmodels OLS")
    print(f"{'Dataset':<10}{'Intercept':>15}{'Slope':>15}")

    for i in range(1, 5):
        intercept, slope = linear_regression(
            anscombe[f"x{i}"], anscombe[f"y{i}"]
        )
        print(f"{i:<10}{intercept:>15.6f}{slope:>15.6f}")

    iterations = 10000
    start = time.perf_counter()

    for _ in range(iterations):
        for i in range(1, 5):
            linear_regression(anscombe[f"x{i}"], anscombe[f"y{i}"])

    elapsed = time.perf_counter() - start

    print(f"\nIterations per dataset: {iterations}")
    print(f"Total regression calls: {iterations * 4}")
    print(f"Elapsed time: {elapsed:.6f} seconds")
    print(
        "Average time per regression: "
        f"{elapsed / (iterations * 4) * 1e6:.3f} microseconds"
    )


if __name__ == "__main__":
    main()
