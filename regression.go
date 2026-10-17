package main

import (
	"fmt"

	"github.com/montanaflynn/stats"
)

// RegressionResult stores the estimated coefficients of a linear model.
type RegressionResult struct {
	Intercept float64
	Slope     float64
}

// linearRegression estimates y = Intercept + Slope*x using the stats package.
func linearRegression(x, y []float64) (RegressionResult, error) {
	if len(x) != len(y) {
		return RegressionResult{}, fmt.Errorf(
			"x and y must have the same number of observations",
		)
	}

	if len(x) < 2 {
		return RegressionResult{}, fmt.Errorf(
			"at least two observations are required",
		)
	}

	points := make(stats.Series, len(x))

	for i := range x {
		points[i] = stats.Coordinate{X: x[i], Y: y[i]}
	}

	fittedPoints, err := stats.LinearRegression(points)
	if err != nil {
		return RegressionResult{}, fmt.Errorf(
			"linear regression failed: %w", err,
		)
	}

	// Find two fitted points with different x values.
	// This is necessary because Dataset IV contains repeated x values.
	for i := 1; i < len(fittedPoints); i++ {
		first := fittedPoints[0]
		second := fittedPoints[i]

		if first.X == second.X {
			continue
		}

		slope := (second.Y - first.Y) / (second.X - first.X)
		intercept := first.Y - slope*first.X

		return RegressionResult{
			Intercept: intercept,
			Slope:     slope,
		}, nil
	}

	return RegressionResult{}, fmt.Errorf(
		"regression requires at least two distinct x values",
	)
}
