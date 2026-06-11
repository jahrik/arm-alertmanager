# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Purpose

Multi-arch Prometheus Alertmanager image: official `prom/alertmanager` (pinned release tag) plus a baked-in example routing config at `/etc/alertmanager/config.yml`. Originally a from-source ARM build for a 2018 Raspberry Pi swarm cluster; revived in 2026 as a thin layer over the now-multi-arch upstream image.

## Commands

```bash
make build                                      # docker build -t jahrik/arm-alertmanager:latest .
docker run -d -p 9093:9093 jahrik/arm-alertmanager:latest
curl -fsS http://localhost:9093/-/healthy       # smoke test
make deploy                                     # docker stack deploy -c docker-compose.yml monitor (needs a swarm)
```

Local `docker` is a Podman shim — base images must be fully qualified (`docker.io/...`), and local builds are amd64 only; arm64 is covered by buildx in CI.

## CI

`.github/workflows/build.yml`: Test job builds the image and curls `/-/healthy` on every PR; Release job (merge to `main` only) does a buildx `linux/amd64,linux/arm64` build and pushes `jahrik/arm-alertmanager:latest` to Docker Hub. Needs `DOCKERHUB_USERNAME`/`DOCKERHUB_TOKEN` repo secrets.

## Quirks

- To bump Alertmanager, change the pinned tag in the `FROM` line (upstream releases: github.com/prometheus/alertmanager/releases).
- `config.yml` is the upstream example routing config (example.org addresses, placeholder PagerDuty keys) — it's a template, not a live config.
- `docker-compose.yml` is a swarm stack fragment: it joins the external `monitor` overlay network shared by the whole monitoring stack (prometheus, grafana, node-exporter, cadvisor siblings) and persists to `/mnt/g1/alertmanager` (a GlusterFS mount on the original cluster — see arm-gluster). Keep that wiring; only the per-arch placement constraints were retired.
