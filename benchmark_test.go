package main

import "testing"

// BenchmarkRegression measures repeated regression calculations
// across all four Anscombe datasets.
func BenchmarkRegression(b *testing.B) {
	datasets := anscombeDatasets()

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		for _, dataset := range datasets {
			_, err := linearRegression(dataset.X, dataset.Y)
			if err != nil {
				b.Fatal(err)
			}
		}
	}
}
