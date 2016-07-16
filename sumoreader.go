package sumoreader

import (
	"os"
	"bufio"
	"strings"
	"bytes"
	"fmt"
)

type SumoReader struct {
	file *os.File
	scanner *bufio.Scanner
	text string
	linesScanned int
}

func NewSumoReader(path string) (*SumoReader, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil,err
	}

	scanner := bufio.NewScanner(file)
	//Skip first line (headers)
	scanner.Scan()


	return &SumoReader{file:file,
		scanner: scanner,
		linesScanned:1,
	},nil
}

func (sr *SumoReader) Close() {
	sr.file.Close()
}

func (sr *SumoReader) Scan() bool {

	fmt.Println("scan")
	var buffer bytes.Buffer
	defer func() {sr.text = buffer.String()}()

	sr.linesScanned++
	if !sr.scanner.Scan() {
		return false
	}

	line := sr.scanner.Text()
	buffer.WriteString(line)
	if isFullRecord(line) {
		return true
	}

	for scanDone := false; !scanDone; {
		sr.linesScanned++
		more := sr.scanner.Scan()
		if !more {
			return false
		}

		fmt.Println("processing more")
		line := sr.scanner.Text()
		fmt.Println("full record?")
		buffer.WriteString(line)
		if recordDone(line) {
			scanDone = true
		}
	}

	return true
}

func (sr *SumoReader) Text() string {
	return sr.text
}

func (sr *SumoReader) Err() error {
	return sr.scanner.Err()
}

func isFullRecord(line string) bool {
	parts := strings.Split(line, ".")

	if len(parts) < 13 {
		return false
	}


	return strings.LastIndex(parts[len(parts) -1],"\"") == len(parts[len(parts) -1]) -1
}

func recordDone(line string) bool {
	return strings.LastIndex(line,"\"") == len(line) -1
}


func (sr *SumoReader) Lines() int {
	return sr.linesScanned
}