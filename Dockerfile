############################
# STAGE 1 - Executable bin
############################
FROM golang:alpine AS builder

# Install git.
RUN apk update && apk add --no-cache git

WORKDIR $GOPATH/src/mypackage/myapp/

COPY . .

# Fetch dependencies.
RUN go mod init

# Using go get.
RUN go get -d -v

# Build the binary.
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/hello

############################
# STAGE 2 - Small image
############################

FROM scratch

# Copy our static executable.
COPY --from=builder /go/bin/hello /go/bin/hello

# Run the hello binary.
ENTRYPOINT ["/go/bin/hello"]