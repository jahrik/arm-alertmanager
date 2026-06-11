# AGENTS.md

Multi-arch Alertmanager image: pinned `FROM` over official `prom/alertmanager` plus `config.yml` baked in at `/etc/alertmanager/config.yml`. Part of the `monitor` swarm stack.

## Commands

```bash
make build                                  # build jahrik/arm-alertmanager:latest
curl -fsS http://localhost:9093/-/healthy   # smoke test a running container
make deploy                                 # swarm stack deploy (stack: monitor)
```

## CI

`build.yml`: Test (build + `/-/healthy`) on PR; Release (buildx amd64+arm64+armv7 push to Docker Hub) on merge to main. Needs `DOCKERHUB_USERNAME`/`DOCKERHUB_TOKEN` secrets.

## Quirks

- Bump Alertmanager via the `FROM` tag (github.com/prometheus/alertmanager/releases).
- `config.yml` is the upstream example config (example.org, placeholder keys) — a template, not live config.
- `docker-compose.yml` is a swarm fragment: external `monitor` overlay network, `/mnt/g1/alertmanager` volume (GlusterFS mount on the original cluster) — keep that wiring.
