FROM alpine
ARG TARGETARCH
WORKDIR /app
COPY --chmod=0755 bin/pocketbase-linux-${TARGETARCH} /usr/bin/pocketbase
VOLUME /app
CMD ["pocketbase", "serve", "--http", "0.0.0.0:8090"]
