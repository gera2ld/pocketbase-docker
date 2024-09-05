default:
  just --list

build:
  docker build -t gera2ld/pocketbase:latest .

push:
  docker push gera2ld/pocketbase:latest
