FROM golang:1.23 AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app
ADD . /app

RUN \
  # git apply drop-accept-encoding.patch && \
  cd pocketbase/examples/base && \
  CGO_ENABLED=0 go build -ldflags "-s -w" -trimpath

FROM alpine
WORKDIR /app

COPY --from=builder /app/pocketbase/examples/base/base /usr/bin/pocketbase
VOLUME /app

CMD ["pocketbase", "serve", "--http", "0.0.0.0:8090"]
