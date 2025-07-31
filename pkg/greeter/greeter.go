package greeter

import (
	"fmt"
	"strings"
)

// Greeter provides greeting functionality
type Greeter struct {
	prefix string
}

// New creates a new Greeter with the given prefix
func New(prefix string) *Greeter {
	return &Greeter{prefix: prefix}
}

// Greet returns a greeting message for the given name
func (g *Greeter) Greet(name string) string {
	if name == "" {
		name = "World"
	}
	return fmt.Sprintf("%s, %s!", g.prefix, name)
}

// GreetUppercase returns an uppercase greeting message
func (g *Greeter) GreetUppercase(name string) string {
	return strings.ToUpper(g.Greet(name))
}

// GreetMultiple returns a greeting for multiple names
func (g *Greeter) GreetMultiple(names []string) []string {
	greetings := make([]string, len(names))
	for i, name := range names {
		greetings[i] = g.Greet(name)
	}
	return greetings
}
