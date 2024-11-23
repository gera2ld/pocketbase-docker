FROM alpine AS downloader

ARG TARGETOS
ARG TARGETARCH
ARG POCKETBASE_VERSION=0.22.27

ADD https://github.com/pocketbase/pocketbase/releases/download/v${POCKETBASE_VERSION}/pocketbase_${POCKETBASE_VERSION}_${TARGETOS}_${TARGETARCH}.zip /tmp/pocketbase.zip
RUN unzip /tmp/pocketbase.zip -d /tmp \
  && mv /tmp/pocketbase /usr/bin/pocketbase

FROM alpine
WORKDIR /app

COPY --from=downloader /usr/bin/pocketbase /usr/bin/pocketbase
VOLUME /app

CMD ["pocketbase", "serve", "--http", "0.0.0.0:8090"]
