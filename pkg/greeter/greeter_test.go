package greeter

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestNew(t *testing.T) {
	g := New("Hello")
	assert.NotNil(t, g)
	assert.Equal(t, "Hello", g.prefix)
}

func TestGreet(t *testing.T) {
	g := New("Hello")

	tests := []struct {
		name     string
		input    string
		expected string
	}{
		{"with name", "Alice", "Hello, Alice!"},
		{"empty name", "", "Hello, World!"},
		{"name with spaces", "John Doe", "Hello, John Doe!"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := g.Greet(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestGreetUppercase(t *testing.T) {
	g := New("Hello")

	tests := []struct {
		name     string
		input    string
		expected string
	}{
		{"with name", "Alice", "HELLO, ALICE!"},
		{"empty name", "", "HELLO, WORLD!"},
		{"lowercase name", "bob", "HELLO, BOB!"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := g.GreetUppercase(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestGreetMultiple(t *testing.T) {
	g := New("Hi")

	tests := []struct {
		name     string
		input    []string
		expected []string
	}{
		{
			"multiple names",
			[]string{"Alice", "Bob", "Charlie"},
			[]string{"Hi, Alice!", "Hi, Bob!", "Hi, Charlie!"},
		},
		{
			"single name",
			[]string{"Alice"},
			[]string{"Hi, Alice!"},
		},
		{
			"empty slice",
			[]string{},
			[]string{},
		},
		{
			"with empty name",
			[]string{"Alice", "", "Bob"},
			[]string{"Hi, Alice!", "Hi, World!", "Hi, Bob!"},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := g.GreetMultiple(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}
