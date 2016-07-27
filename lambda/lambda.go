package main

import (
	"bytes"
	"fmt"
	"github.com/bitly/go-simplejson"
	"log"
	"os"
)

func main() {
	fmt.Printf("Go binary called with args %v\n", os.Args)
	buf := bytes.NewBuffer([]byte(os.Args[1]))
	js, err := simplejson.NewFromReader(buf)
	if err != nil {
		log.Fatal(err.Error)
	}

	records := js.Get("Records")

	arr, err := records.Array()
	if err != nil {
		log.Fatal(err)
	}

	for i := 0; i < len(arr); i++ {
		s3 := records.GetIndex(i).Get("s3")

		key := s3.Get("object").Get("key")
		bucket := s3.Get("bucket")
		arn := bucket.Get("arn")
		bucketName := bucket.Get("name")

		fmt.Printf("process %s in bucket %s (%s)\n", key.MustString(), bucketName.MustString(), arn.MustString())

	}

}
