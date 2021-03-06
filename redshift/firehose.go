package main

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/firehose"
)

func main() {
	sess, err := session.NewSession()
	if err != nil {
		fmt.Println("failed to create session,", err)
		return
	}

	svc := firehose.New(sess)

	params := &firehose.PutRecordInput{
		DeliveryStreamName: aws.String("call-record-stream"),
		Record: &firehose.Record{
			//Data: []byte("2016-07-01 15:22:58|56bfe3d5-5204-ec24-077d-6a8213fdf8a5|false|vc2coma2078845n|/xapi/DEV/NONPROD|xtracApi-POST-workItems-search|XWHRon|a79fcb28-2621-4973-8a1e-c09a2ab30f79|1431\n"),
			Data: []byte("2016-07-01 15:22:58|181c575a-ef8c-4468-76e3-3c95ff3a5e4b|false|vc2coma2078845n|/xapi/DEV/NONPROD|xtracApi-GET-work-items-communications|XWHRon|a79fcb28-2621-4973-8a1e-c09a2ab30f79|262\n"),
		},
	}


	fmt.Printf("Sending %s\n", string(params.Record.Data))
	resp, err := svc.PutRecord(params)

	if err != nil {
		fmt.Println(err.Error())
		return
	}

	fmt.Println(resp)
}
