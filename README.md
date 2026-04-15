# container-ansible

Container image for running [Ansible Molecule](https://ansible.readthedocs.io/projects/molecule/) tests. Based on Rocky Linux 10 (UBI), built for `linux/amd64` and published to GitHub Container Registry.

## Included Tools

| Tool | Version |
|------|---------|
| ansible-core | 2.20.4 |
| molecule | 26.4.0 |
| molecule-plugins | 25.8.12 |
| ansible-lint | 26.4.0 |
| yamllint | 1.38.0 |

## Usage

Pull the image:

```bash
docker pull ghcr.io/truestory1/container-ansible:YYYYMMDD
```

Run a Molecule scenario:

```bash
docker run --rm -v "$(pwd):/work" -w /work \
  ghcr.io/truestory1/container-ansible:YYYYMMDD \
  molecule test -s <scenario-name>
```

Replace `<scenario-name>` with the name of the Molecule scenario to run (e.g. `default`).

## Building Locally

```bash
docker build -f Containerfile -t container-ansible .
```

## CI/CD

| Workflow | Trigger | Description |
|----------|---------|-------------|
| **Build** | Push to `master`, manual | Builds the image and pushes to GHCR with a date-based tag |
| **CI-PR** | Pull request, manual | Builds the image and runs smoke tests (`uname`, `ansible`, `molecule`) |

## Image Tags

- `YYYYMMDD` — date-stamped tag from the build on `master`
