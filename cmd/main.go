package main

import (
	"os"
	"log"
	"github.com/d-smith/sumoreader"
	"github.com/d-smith/sumoreader/apitimings"
	"fmt"
	"strings"
)

func main() {
	if len(os.Args) != 2 {
		log.Fatal("usage: " + os.Args[0] + " <file path>")
	}

	sr, err := sumoreader.NewSumoReader(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}

	var count = 1
	for sr.Scan() {
		line := sr.Text()
		if strings.Contains(line, "{") {
			//fmt.Println(sr.Text())
			at,err := apitimings.NewAPITimingRec(line)
			if err != nil {
				fmt.Println(err.Error())
				continue
			}
			cr,_ := at.CallRecord()
			fmt.Println(cr)
		}
		count++
	}

	if err := sr.Err(); err != nil {
		log.Fatal(err)
	}

	fmt.Println("read", sr.Lines())
}
