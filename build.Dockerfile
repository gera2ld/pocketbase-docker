FROM golang:1.23 AS builder

ARG TARGETOS
ARG TARGETARCH
ARG POCKETBASE_REF=master

WORKDIR /app
ADD . /app

RUN \
  git clone --branch $POCKETBASE_REF --depth 1 https://github.com/pocketbase/pocketbase.git \
  && cd pocketbase/examples/base \
  && CGO_ENABLED=0 go build -ldflags "-s -w" -trimpath

FROM alpine
WORKDIR /app

COPY --from=builder /app/pocketbase/examples/base/base /usr/bin/pocketbase
VOLUME /app

CMD ["pocketbase", "serve", "--http", "0.0.0.0:8090"]
