package main

import (
	"bytes"
	"fmt"
	"github.com/bitly/go-simplejson"
	"log"
	"os"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/aws"
	"io"
	"github.com/d-smith/sumoreader"
	"strings"
	"github.com/d-smith/sumoreader/apitimings"
)

func processBody(body io.Reader) error {
	sr, err := sumoreader.NewSumoReader(body)
	if err != nil {
		log.Fatal(err)
	}

	for sr.Scan() {
		line := sr.Text()
		if strings.Contains(line, "{") {
			//fmt.Println(sr.Text())
			at, err := apitimings.NewAPITimingRec(line)
			if err != nil {
				fmt.Println(err.Error())
				continue
			}
			cr, _ := at.CallRecord()
			fmt.Println(cr)
			calls, err := at.ServiceCalls()

			if err != nil {
				fmt.Println(err.Error())
				continue
			}

			for _, c := range calls {
				fmt.Println(c)
			}
		}
	}

	if err := sr.Err(); err != nil {
		return err
	}

	return nil
}

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

	sess, err := session. NewSession()
	if err != nil {
		fmt.Println("failed to create session,", err)
		return
	}

	svc := s3.New(sess)


	for i := 0; i < len(arr); i++ {
		s3Rec := records.GetIndex(i).Get("s3")

		key := s3Rec.Get("object").Get("key")
		bucket := s3Rec.Get("bucket")
		arn := bucket.Get("arn")
		bucketName := bucket.Get("name")

		fmt.Printf("process %s in bucket %s (%s)\n", key.MustString(), bucketName.MustString(), arn.MustString())

		params := &s3.GetObjectInput{
			Bucket:                     aws.String(bucketName.MustString()),
			Key:                        aws.String(key.MustString()),
		}

		resp, err := svc.GetObject(params)
		if err != nil {
			fmt.Printf("Error on GetObject: %s\n", err.Error())
			continue
		}

		if resp.Body == nil {
			fmt.Println("Nil body - nothing to read.")
			continue
		}

		defer resp.Body.Close()

		processBody(resp.Body)

	}

}
