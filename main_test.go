package main

import (
	"os/exec"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// Integration tests that test the actual binary
func TestCLIIntegration(t *testing.T) {
	// Build the binary first
	buildCmd := exec.Command("go", "build", "-o", "go-cli-test-test", ".")
	err := buildCmd.Run()
	require.NoError(t, err, "Failed to build test binary")

	// Clean up after tests
	defer func() {
		cleanCmd := exec.Command("rm", "-f", "go-cli-test-test")
		cleanCmd.Run()
	}()

	tests := []struct {
		name     string
		args     []string
		expected string
	}{
		{
			name:     "help command",
			args:     []string{"--help"},
			expected: "A demonstration CLI application",
		},
		{
			name:     "greet without name",
			args:     []string{"greet"},
			expected: "Hello, World!",
		},
		{
			name:     "greet with name",
			args:     []string{"greet", "Alice"},
			expected: "Hello, Alice!",
		},
		{
			name:     "math add",
			args:     []string{"math", "add", "10", "20"},
			expected: "Result: 30.00",
		},
		{
			name:     "math multiply",
			args:     []string{"math", "multiply", "3", "4"},
			expected: "Result: 12.00",
		},
		{
			name:     "math sqrt",
			args:     []string{"math", "sqrt", "9"},
			expected: "Result: 3.000000",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			cmd := exec.Command("./go-cli-test-test", tt.args...)
			output, err := cmd.CombinedOutput()

			assert.NoError(t, err, "Command should not fail")
			assert.Contains(t, string(output), tt.expected)
		})
	}
}

func TestCLIErrorCases(t *testing.T) {
	// Build the binary first
	buildCmd := exec.Command("go", "build", "-o", "go-cli-test-test", ".")
	err := buildCmd.Run()
	require.NoError(t, err, "Failed to build test binary")

	// Clean up after tests
	defer func() {
		cleanCmd := exec.Command("rm", "-f", "go-cli-test-test")
		cleanCmd.Run()
	}()

	tests := []struct {
		name        string
		args        []string
		expectError bool
		errorText   string
	}{
		{
			name:        "math add with insufficient args",
			args:        []string{"math", "add", "1"},
			expectError: true,
			errorText:   "requires at least 2 arg(s)",
		},
		{
			name:        "math divide by zero",
			args:        []string{"math", "divide", "10", "0"},
			expectError: false, // Our app handles this gracefully
			errorText:   "division by zero",
		},
		{
			name:        "invalid subcommand",
			args:        []string{"invalid"},
			expectError: true,
			errorText:   "unknown command",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			cmd := exec.Command("./go-cli-test-test", tt.args...)
			output, err := cmd.CombinedOutput()

			if tt.expectError {
				assert.Error(t, err, "Command should fail")
			}

			if tt.errorText != "" {
				outputStr := strings.ToLower(string(output))
				errorTextLower := strings.ToLower(tt.errorText)
				assert.Contains(t, outputStr, errorTextLower)
			}
		})
	}
}
