# container-ansible

Container image based on Rocky Linux 10 (UBI init) with Ansible tooling pre-installed. Built for multi-architecture (`linux/amd64`, `linux/arm64`) and published to GitHub Container Registry.

## Included Tools

| Tool | Version |
|------|---------|
| ansible-core | 2.20.4 |
| molecule | 26.4.0 |
| molecule-plugins | 25.8.12 |
| ansible-lint | 26.4.0 |
| yamllint | 1.38.0 |

## Usage

Pull the image from GHCR:

```bash
docker pull ghcr.io/<owner>/container-ansible:latest
```

Run interactively:

```bash
docker run --rm -it ghcr.io/<owner>/container-ansible:latest bash
```

## Building Locally

```bash
docker build -f rockylinux-10/Containerfile -t container-ansible rockylinux-10/
```

## CI/CD

| Workflow | Trigger | Description |
|----------|---------|-------------|
| **buildx** | Push to `master` | Builds multi-arch image and pushes to GHCR with calendar-versioned tags (`YYYY`, `YYYY.MM`, `YYYY.MM.DD`, `latest`) |
| **CI-PR** | Pull request | Builds the image and runs a basic smoke test |
| **Molecule** | Pull request to `master` | Installs dependencies and runs Molecule tests |

## Image Tags

- `latest` — most recent build from `master`
- `YYYY.MM.DD` — full date tag
- `YYYY.MM` — minor version tag
- `YYYY` — major version tag
