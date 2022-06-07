FROM golang:1.18.3 as build

COPY app /opt/app
WORKDIR /opt/app
RUN go env -w GO111MODULE=off && \
    go build


FROM alpine:latest
COPY --from=build /opt/app/main /opt/

ENTRYPOINT ["/opt/main"]

