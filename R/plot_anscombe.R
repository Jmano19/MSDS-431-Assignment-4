# <CodeBlock language="r" editable>
# Plot Anscombe's Quartet with a regression line for each dataset.
# Output: results/anscombe_quartet.png

output_dir <- "results"
if (!dir.exists(output_dir)) {
dir.create(output_dir, recursive = TRUE)
}

# Use the built-in Anscombe dataset included with R.

data("anscombe", package = "datasets")
datasets <- list(
list(name = "Dataset I", x = anscombe$x1, y = anscombe$y1),
list(name = "Dataset II", x = anscombe$x2, y = anscombe$y2),
list(name = "Dataset III", x = anscombe$x3, y = anscombe$y3),
list(name = "Dataset IV", x = anscombe$x4, y = anscombe$y4)
)
output_file <- file.path(output_dir, "anscombe_quartet.png")
png(
filename = output_file,
width = 1400,
height = 1000,
res = 150
)

# Use the same axis limits for all four panels.

old_par <- par(
mfrow = c(2, 2),
mar = c(4, 4, 3, 1),
oma = c(0, 0, 3, 0)
)
for (dataset in datasets) {
plot(
dataset$x,
dataset$y,
main = dataset$name,
xlab = "X",
ylab = "Y",
xlim = c(3, 20),
ylim = c(2, 14),
pch = 19,
col = "darkorange",
cex = 1.2
)

# Fit and draw the least-squares regression line.

model <- lm(dataset$y ~ dataset$x)
abline(
model,
col = "steelblue",
lwd = 2
)
}
mtext(
"Anscombe's Quartet: Similar Regression, Different Data",
outer = TRUE,
cex = 1.3,
font = 2
)
par(old_par)
dev.off()
cat("Visualization saved to:", output_file, "\n")
# </CodeBlock>