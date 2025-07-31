package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "go-cli-test",
	Short: "A simple CLI tool built with Go",
	Long: `A demonstration CLI application that showcases:
- Go development with Cobra
- Pre-commit hooks for code quality
- Unit testing best practices`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Welcome to go-cli-test! Use --help to see available commands.")
	},
}

// Execute runs the root command
func Execute() error {
	return rootCmd.Execute()
}

func init() {
	rootCmd.AddCommand(greetCmd)
	rootCmd.AddCommand(mathCmd)
}
