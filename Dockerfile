FROM golang:1.14.3 as builder

WORKDIR /src

COPY go.mod /src/go.mod
COPY go.sum /src/go.sum

RUN go mod download

# Perform the build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=ppc64le go build -ldflags="-w -s" -o /dist/gitops ./agent


FROM alpine/git:v2.24.3
COPY --from=builder /dist/gitops /usr/local/bin/gitops
