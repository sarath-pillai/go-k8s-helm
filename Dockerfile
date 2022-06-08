FROM golang:1.18.3 as build

COPY app /opt/app
WORKDIR /opt/app
ENV GOOS=linux
ENV GOARCH=amd64
RUN go env -w GO111MODULE=off && \
    go build


FROM amd64/alpine:latest
COPY --from=build /opt/app/main /opt/

ENTRYPOINT ["/opt/main"]

