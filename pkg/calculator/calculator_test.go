package calculator

import (
	"math"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestAdd(t *testing.T) {
	tests := []struct {
		name     string
		a, b     float64
		expected float64
	}{
		{"positive numbers", 2.5, 3.5, 6.0},
		{"negative numbers", -2.0, -3.0, -5.0},
		{"mixed signs", -2.0, 3.0, 1.0},
		{"with zero", 5.0, 0.0, 5.0},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := Add(tt.a, tt.b)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestSubtract(t *testing.T) {
	tests := []struct {
		name     string
		a, b     float64
		expected float64
	}{
		{"positive numbers", 5.0, 3.0, 2.0},
		{"negative result", 3.0, 5.0, -2.0},
		{"negative numbers", -2.0, -3.0, 1.0},
		{"with zero", 5.0, 0.0, 5.0},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := Subtract(tt.a, tt.b)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestMultiply(t *testing.T) {
	tests := []struct {
		name     string
		a, b     float64
		expected float64
	}{
		{"positive numbers", 3.0, 4.0, 12.0},
		{"negative numbers", -2.0, -3.0, 6.0},
		{"mixed signs", -2.0, 3.0, -6.0},
		{"with zero", 5.0, 0.0, 0.0},
		{"with one", 7.0, 1.0, 7.0},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := Multiply(tt.a, tt.b)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestDivide(t *testing.T) {
	tests := []struct {
		name        string
		a, b        float64
		expected    float64
		shouldError bool
	}{
		{"positive numbers", 10.0, 2.0, 5.0, false},
		{"negative numbers", -10.0, -2.0, 5.0, false},
		{"mixed signs", -10.0, 2.0, -5.0, false},
		{"division by zero", 5.0, 0.0, 0.0, true},
		{"zero dividend", 0.0, 5.0, 0.0, false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result, err := Divide(tt.a, tt.b)
			if tt.shouldError {
				assert.Error(t, err)
				assert.Contains(t, err.Error(), "division by zero")
			} else {
				assert.NoError(t, err)
				assert.Equal(t, tt.expected, result)
			}
		})
	}
}

func TestPower(t *testing.T) {
	tests := []struct {
		name     string
		a, b     float64
		expected float64
	}{
		{"positive base and exponent", 2.0, 3.0, 8.0},
		{"power of zero", 5.0, 0.0, 1.0},
		{"power of one", 5.0, 1.0, 5.0},
		{"negative exponent", 2.0, -2.0, 0.25},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := Power(tt.a, tt.b)
			assert.InDelta(t, tt.expected, result, 0.0001)
		})
	}
}

func TestSqrt(t *testing.T) {
	tests := []struct {
		name        string
		a           float64
		expected    float64
		shouldError bool
	}{
		{"perfect square", 9.0, 3.0, false},
		{"positive number", 2.0, math.Sqrt(2), false},
		{"zero", 0.0, 0.0, false},
		{"negative number", -4.0, 0.0, true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result, err := Sqrt(tt.a)
			if tt.shouldError {
				assert.Error(t, err)
				assert.Contains(t, err.Error(), "negative number")
			} else {
				assert.NoError(t, err)
				assert.InDelta(t, tt.expected, result, 0.0001)
			}
		})
	}
}
