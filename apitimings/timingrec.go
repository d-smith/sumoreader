package apitimings

import (
	"strings"
	"fmt"
	"strconv"
)

type APITimingRec struct {
	MsgId int
	SourceName string
	SourceHost string
	SourceCategory string
	Message string
}

func NewAPITimingRec(raw string) (*APITimingRec,error) {
	parts :=strings.Split(raw,",")
	fmt.Println("\tThis many parts:",len(parts))
	fmt.Println("\tMessage id:",parts[0])
	fmt.Println("\tSource name:",parts[1])
	fmt.Println("\tSource host:",parts[2])
	fmt.Println("\tSource category", parts[3])
	fmt.Println("\tMsg", extractMessage(raw))

	id,err := strconv.Atoi(parts[0])
	if err != nil {
		return nil,err
	}

	return &APITimingRec{
		MsgId: id,
		SourceName: parts[1],
		SourceHost: parts[2],
		SourceCategory:parts[3],

	},nil
}

func extractMessage(raw string) string {
	parts :=strings.Split(raw,",")
	m := strings.Join(parts[11:], ",")
	m = m[strings.Index(m,"{"):]
	m = m[:len(m)-1]
	m = strings.Replace(m,"\n","",-1)
	m = strings.Replace(m,"\"\"","\"",-1)
	return m
}
