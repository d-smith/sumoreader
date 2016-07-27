package:
	rm lambda
	rm lambda.zip
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o lambda
	zip lambda.zip index.js lambda
