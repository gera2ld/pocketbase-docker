FROM alpine AS builder
ARG TARGETARCH
WORKDIR /usr/bin
ADD bin/pocketbase-linux-${TARGETARCH} pocketbase
RUN chmod +x pocketbase

FROM alpine
WORKDIR /app
COPY --from=builder /usr/bin/pocketbase /usr/bin/pocketbase
VOLUME /app
CMD ["pocketbase", "serve", "--http", "0.0.0.0:8090"]
