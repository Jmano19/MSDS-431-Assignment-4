
anscombe <- data.frame(
  x1 = c(10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5),
  x2 = c(10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5),
  x3 = c(10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5),
  x4 = c(8, 8, 8, 8, 8, 8, 8, 19, 8, 8, 8),
  y1 = c(8.04, 6.95, 7.58, 8.81, 8.33, 9.96, 7.24, 4.26, 10.84, 4.82, 5.68),
  y2 = c(9.14, 8.14, 8.74, 8.77, 9.26, 8.10, 6.13, 3.10, 9.13, 7.26, 4.74),
  y3 = c(7.46, 6.77, 12.74, 7.11, 7.81, 8.84, 6.08, 5.39, 8.15, 6.42, 5.73),
  y4 = c(6.58, 5.76, 7.71, 8.84, 8.47, 7.04, 5.25, 12.50, 5.56, 7.91, 6.89)
)

linear_regression <- function(x, y) {
  model <- lm(y ~ x)
  coefficients <- coef(model)

  c(
    intercept = unname(coefficients[1]),
    slope = unname(coefficients[2])
  )
}

cat("Anscombe Quartet: R lm()\n")
cat(sprintf("%-10s %15s %15s\n", "Dataset", "Intercept", "Slope"))

for (i in 1:4) {
  result <- linear_regression(
    anscombe[[paste0("x", i)]],
    anscombe[[paste0("y", i)]]
  )

  cat(sprintf("%-10d %15.6f %15.6f\n",
              i, result[1], result[2]))
}

iterations <- 10000

elapsed <- system.time({
  for (iteration in seq_len(iterations)) {
    for (i in 1:4) {
      linear_regression(
        anscombe[[paste0("x", i)]],
        anscombe[[paste0("y", i)]]
      )
    }
  }
})[["elapsed"]]

cat(sprintf("\nIterations per dataset: %d\n", iterations))
cat(sprintf("Total regression calls: %d\n", iterations * 4))
cat(sprintf("Elapsed time: %.6f seconds\n", elapsed))
cat(sprintf("Average time per regression: %.3f microseconds\n",
            elapsed / (iterations * 4) * 1e6))
