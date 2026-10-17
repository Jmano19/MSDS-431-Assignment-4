package main

import (
	"math"
	"testing"
)

func TestAnscombeRegression(t *testing.T) {
	tests := []struct {
		name          string
		x             []float64
		y             []float64
		wantIntercept float64
		wantSlope     float64
	}{
		{
			name:          "Dataset I",
			x:             []float64{10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5},
			y:             []float64{8.04, 6.95, 7.58, 8.81, 8.33, 9.96, 7.24, 4.26, 10.84, 4.82, 5.68},
			wantIntercept: 3.0000909,
			wantSlope:     0.5000909,
		},
		{
			name:          "Dataset II",
			x:             []float64{10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5},
			y:             []float64{9.14, 8.14, 8.74, 8.77, 9.26, 8.10, 6.13, 3.10, 9.13, 7.26, 4.74},
			wantIntercept: 3.0009091,
			wantSlope:     0.5,
		},
		{
			name:          "Dataset III",
			x:             []float64{10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5},
			y:             []float64{7.46, 6.77, 12.74, 7.11, 7.81, 8.84, 6.08, 5.39, 8.15, 6.42, 5.73},
			wantIntercept: 3.0024545,
			wantSlope:     0.4997273,
		},
		{
			name:          "Dataset IV",
			x:             []float64{8, 8, 8, 8, 8, 8, 8, 19, 8, 8, 8},
			y:             []float64{6.58, 5.76, 7.71, 8.84, 8.47, 7.04, 5.25, 12.50, 5.56, 7.91, 6.89},
			wantIntercept: 3.0017273,
			wantSlope:     0.4999091,
		},
	}

	const tolerance = 0.00001

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got, err := linearRegression(test.x, test.y)
			if err != nil {
				t.Fatalf("linearRegression returned an error: %v", err)
			}

			if math.Abs(got.Intercept-test.wantIntercept) > tolerance {
				t.Errorf("intercept = %.7f, want %.7f",
					got.Intercept, test.wantIntercept)
			}

			if math.Abs(got.Slope-test.wantSlope) > tolerance {
				t.Errorf("slope = %.7f, want %.7f",
					got.Slope, test.wantSlope)
			}
		})
	}
}

func TestLinearRegressionRejectsInvalidInput(t *testing.T) {
	tests := []struct {
		name string
		x    []float64
		y    []float64
	}{
		{
			name: "mismatched lengths",
			x:    []float64{1, 2, 3},
			y:    []float64{2, 4},
		},
		{
			name: "insufficient observations",
			x:    []float64{1},
			y:    []float64{2},
		},
		{
			name: "identical x values",
			x:    []float64{5, 5, 5},
			y:    []float64{1, 2, 3},
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			_, err := linearRegression(test.x, test.y)
			if err == nil {
				t.Fatal("expected an error for invalid input")
			}
		})
	}
}
