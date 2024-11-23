# pocketbase-docker

## Features

- Patched PocketBase to always ignore `Accept-Encoding` header for S3, which makes it possible to support S3 compatible services behind a reverse-proxy like Cloudflare. ([Discussion](https://github.com/pocketbase/pocketbase/discussions/5917))

## Usage

```yaml
services:
  pocketbase:
    image: gera2ld/pocketbase
    volumes:
      - ./data:/app/data
```
