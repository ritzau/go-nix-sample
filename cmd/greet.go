package cmd

import (
	"fmt"

	"go-cli-test/pkg/greeter"

	"github.com/spf13/cobra"
)

var greetCmd = &cobra.Command{
	Use:   "greet [name]",
	Short: "Greet someone",
	Long:  "Greet someone with a personalized message",
	Args:  cobra.MaximumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		name := ""
		if len(args) > 0 {
			name = args[0]
		}

		uppercase, _ := cmd.Flags().GetBool("uppercase")
		prefix, _ := cmd.Flags().GetString("prefix")

		g := greeter.New(prefix)

		var greeting string
		if uppercase {
			greeting = g.GreetUppercase(name)
		} else {
			greeting = g.Greet(name)
		}

		fmt.Println(greeting)
	},
}

func init() {
	greetCmd.Flags().BoolP("uppercase", "u", false, "Print greeting in uppercase")
	greetCmd.Flags().StringP("prefix", "p", "Hello", "Greeting prefix")
}
