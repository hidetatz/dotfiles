package main

import (
	"fmt"
	"os"
	"text/tabwriter"
)

func main() {
	w := new(tabwriter.Writer)
	w.Init(os.Stdout, 0, 8, 2, ' ', 0)
	fmt.Fprintf(w, "%s\t%s\n", "aaa:", "bbb")
	fmt.Fprintf(w, "%s\t%s\n", "cccaaaaaaaaaaaaaaaaa:", "bbb")
	fmt.Fprintf(w, "\t%s\n", "bbb")
	fmt.Fprintf(w, "\t%s\n", "3bb")
	fmt.Fprintf(w, "\t%s\n", "fbb")
	fmt.Fprintf(w, "\t%s\n", "xbb")
	fmt.Fprintf(w, "%s\t%s\n", "ddd:", "bbb")

	w.Flush()
}
