package cmd

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestRootCommand(t *testing.T) {
	// Test that the root command exists
	assert.NotNil(t, rootCmd)
	assert.Equal(t, "go-cli-test", rootCmd.Use)
	assert.Contains(t, rootCmd.Short, "A simple CLI tool")
}

func TestGreetCommandExists(t *testing.T) {
	// Test that the greet command is properly registered
	_, _, err := rootCmd.Find([]string{"greet"})
	assert.NoError(t, err)
}

func TestMathCommandExists(t *testing.T) {
	// Test that the math command is properly registered
	_, _, err := rootCmd.Find([]string{"math"})
	assert.NoError(t, err)
}
