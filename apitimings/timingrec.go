package apitimings

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
)

type APITimingRec struct {
	MsgId          int
	SourceName     string
	SourceHost     string
	SourceCategory string
	Message        string
}

func NewAPITimingRec(raw string) (*APITimingRec, error) {
	parts := strings.Split(raw, ",")

	id, err := strconv.Atoi(strings.Replace(parts[0], "\"", "", -1))
	if err != nil {
		return nil, err
	}

	return &APITimingRec{
		MsgId:          id,
		SourceName:     parts[1],
		SourceHost:     parts[2],
		SourceCategory: parts[3],
		Message:        extractMessage(raw),
	}, nil
}

func extractMessage(raw string) string {
	parts := strings.Split(raw, ",")
	m := strings.Join(parts[11:], ",")
	m = m[strings.Index(m, "{"):]
	m = m[:len(m)-1]
	m = strings.Replace(m, "\n", "", -1)
	m = strings.Replace(m, "\"\"", "\"", -1)
	return m
}

func unquote(s string) string {
	return s[1 : len(s)-1]
}

func (at *APITimingRec) CallRecord() (string, error) {
	var callRecord endToEndTimer

	err := json.Unmarshal([]byte(at.Message), &callRecord)
	if err != nil {
		return "", err
	}

	sub := callRecord.Tags["sub"]
	aud := callRecord.Tags["aud"]

	return fmt.Sprintf("%s|%s|%s|%s|%s|%s|%d",
		callRecord.TxnId,
		unquote(at.SourceHost),
		unquote(at.SourceCategory),
		callRecord.Name,
		sub,
		aud,
		callRecord.Duration.Nanoseconds()), nil
}
