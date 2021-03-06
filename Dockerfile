FROM golang:1.13 as build

COPY app /opt/app
WORKDIR /opt/app

RUN go env -w GO111MODULE=off && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -ldflags '-w -extldflags "-static"'

FROM scratch
COPY --from=build /opt/app/app /opt/

ENTRYPOINT ["/opt/app"]

