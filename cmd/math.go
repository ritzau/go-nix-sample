package cmd

import (
	"fmt"
	"strconv"

	"go-cli-test/pkg/calculator"

	"github.com/spf13/cobra"
)

var mathCmd = &cobra.Command{
	Use:   "math",
	Short: "Mathematical operations",
	Long:  "Perform various mathematical operations",
}

var addCmd = &cobra.Command{
	Use:   "add [numbers...]",
	Short: "Add numbers together",
	Long:  "Add two or more numbers together",
	Args:  cobra.MinimumNArgs(2),
	Run: func(cmd *cobra.Command, args []string) {
		var result float64
		for i, arg := range args {
			num, err := strconv.ParseFloat(arg, 64)
			if err != nil {
				fmt.Printf("Error: '%s' is not a valid number\n", arg)
				return
			}
			if i == 0 {
				result = num
			} else {
				result = calculator.Add(result, num)
			}
		}
		fmt.Printf("Result: %.2f\n", result)
	},
}

var multiplyCmd = &cobra.Command{
	Use:   "multiply [numbers...]",
	Short: "Multiply numbers together",
	Long:  "Multiply two or more numbers together",
	Args:  cobra.MinimumNArgs(2),
	Run: func(cmd *cobra.Command, args []string) {
		result := 1.0
		for _, arg := range args {
			num, err := strconv.ParseFloat(arg, 64)
			if err != nil {
				fmt.Printf("Error: '%s' is not a valid number\n", arg)
				return
			}
			result = calculator.Multiply(result, num)
		}
		fmt.Printf("Result: %.2f\n", result)
	},
}

var divideCmd = &cobra.Command{
	Use:   "divide [dividend] [divisor]",
	Short: "Divide two numbers",
	Long:  "Divide the first number by the second number",
	Args:  cobra.ExactArgs(2),
	Run: func(cmd *cobra.Command, args []string) {
		dividend, err := strconv.ParseFloat(args[0], 64)
		if err != nil {
			fmt.Printf("Error: '%s' is not a valid number\n", args[0])
			return
		}

		divisor, err := strconv.ParseFloat(args[1], 64)
		if err != nil {
			fmt.Printf("Error: '%s' is not a valid number\n", args[1])
			return
		}

		result, err := calculator.Divide(dividend, divisor)
		if err != nil {
			fmt.Printf("Error: %v\n", err)
			return
		}

		fmt.Printf("Result: %.2f\n", result)
	},
}

var sqrtCmd = &cobra.Command{
	Use:   "sqrt [number]",
	Short: "Calculate square root",
	Long:  "Calculate the square root of a number",
	Args:  cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		num, err := strconv.ParseFloat(args[0], 64)
		if err != nil {
			fmt.Printf("Error: '%s' is not a valid number\n", args[0])
			return
		}

		result, err := calculator.Sqrt(num)
		if err != nil {
			fmt.Printf("Error: %v\n", err)
			return
		}

		fmt.Printf("Result: %.6f\n", result)
	},
}

func init() {
	mathCmd.AddCommand(addCmd)
	mathCmd.AddCommand(multiplyCmd)
	mathCmd.AddCommand(divideCmd)
	mathCmd.AddCommand(sqrtCmd)
}
