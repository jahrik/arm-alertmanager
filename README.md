# arm-alertmanager

[![Build](https://github.com/jahrik/arm-alertmanager/actions/workflows/build.yml/badge.svg)](https://github.com/jahrik/arm-alertmanager/actions/workflows/build.yml)

Multi-arch [Alertmanager](https://github.com/prometheus/alertmanager) image with a baked-in routing config, part of the `monitor` swarm stack. Built for a 2018 Pi swarm cluster; now a pinned layer over the official `prom/alertmanager` image.

## Run

```bash
docker run -d -p 9093:9093 jahrik/arm-alertmanager:latest
curl http://localhost:9093/-/healthy
```

Config lives at `/etc/alertmanager/config.yml` — edit `config.yml` and rebuild, or bind-mount your own.

## Deploy (swarm)

```bash
docker network create -d overlay monitor   # once
make deploy                                # data persists to /mnt/g1/alertmanager
```

## Build

```bash
make build
make push
```

CI: PR builds + health check; merge to main pushes multi-arch (amd64/arm64) to Docker Hub.
