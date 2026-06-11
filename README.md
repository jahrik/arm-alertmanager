# arm-alertmanager

[![Build](https://github.com/jahrik/arm-alertmanager/actions/workflows/build.yml/badge.svg)](https://github.com/jahrik/arm-alertmanager/actions/workflows/build.yml)

Multi-arch [Prometheus Alertmanager](https://github.com/prometheus/alertmanager) image with a baked-in example routing config.

Originally built (~2018) for a Raspberry Pi / ARM Docker Swarm cluster by compiling Alertmanager from source, back when upstream shipped no ARM images. Upstream's [`prom/alertmanager`](https://hub.docker.com/r/prom/alertmanager) is multi-arch now, so this image is based directly on it (pinned release) and just adds the config layer. Use the upstream image directly if you don't need the baked-in config.

## Usage

```bash
docker pull jahrik/arm-alertmanager:latest
docker run -d -p 9093:9093 -v alertmanager-data:/alertmanager jahrik/arm-alertmanager:latest
curl http://localhost:9093/-/healthy
```

The config lives at `/etc/alertmanager/config.yml` — edit `config.yml` in this repo and rebuild, or bind-mount your own:

```bash
docker run -d -p 9093:9093 -v ./config.yml:/etc/alertmanager/config.yml jahrik/arm-alertmanager:latest
```

Or deploy to a swarm as part of the `monitor` stack (expects the external `monitor` overlay network to exist, and persists data to `/mnt/g1/alertmanager` — a GlusterFS mount on the original cluster):

```bash
docker network create -d overlay monitor   # once, on the swarm
make deploy                                # docker stack deploy -c docker-compose.yml monitor
```

## Build

```bash
make build    # docker build -t jahrik/arm-alertmanager:latest .
make push
```

CI builds and tests the image on every PR and pushes a multi-arch (`linux/amd64`, `linux/arm64`) image to Docker Hub on merge to main.
