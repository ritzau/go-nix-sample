package cmd

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

// Test the math functions directly rather than through CLI
// The integration tests in main_test.go test the CLI interface

func TestMathCommandValidation(t *testing.T) {
	// Test that the math command exists and has subcommands
	assert.NotNil(t, mathCmd)
	assert.True(t, mathCmd.HasSubCommands())

	// Check that subcommands exist
	_, _, err := mathCmd.Find([]string{"add"})
	assert.NoError(t, err)

	_, _, err = mathCmd.Find([]string{"multiply"})
	assert.NoError(t, err)

	_, _, err = mathCmd.Find([]string{"divide"})
	assert.NoError(t, err)

	_, _, err = mathCmd.Find([]string{"sqrt"})
	assert.NoError(t, err)
}
