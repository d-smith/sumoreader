package apitimings

import (
	"strings"
	"strconv"
	"encoding/json"
	"fmt"
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

	id,err := strconv.Atoi(strings.Replace(parts[0], "\"", "", -1))
	if err != nil {
		return nil,err
	}

	return &APITimingRec{
		MsgId: id,
		SourceName: parts[1],
		SourceHost: parts[2],
		SourceCategory:parts[3],
		Message:extractMessage(raw),
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


func (at *APITimingRec) CallRecord() (string,error) {
	var callRecord endToEndTimer

	err := json.Unmarshal([]byte(at.Message), &callRecord)
	if err != nil {
		return "",err
	}

	return fmt.Sprintf("%d|%s|%s|%s|%s|%s|%d",
		at.MsgId,
		at.SourceName,
		at.SourceHost,
		at.SourceCategory,
		callRecord.Name,
		callRecord.Tags,
		callRecord.Duration.Nanoseconds()),nil
}