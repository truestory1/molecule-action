# Ansible Molecule GitHub Action

A GitHub Action for running [Ansible Molecule](https://ansible.readthedocs.io/projects/molecule/) tests in CI/CD pipelines.

**Included versions:**
- ansible-core 2.20.5
- molecule 26.4.0 with molecule-plugins 25.8.12
- ansible-lint 26.4.0
- yamllint 1.38.0

The action container is Debian-based and includes both Docker CE and Podman. It supports all three major container drivers:

- **docker** – uses the host Docker daemon via the mounted Docker socket
- **podman** – uses the host Podman daemon via the mounted Podman socket
- **containers** – uses the Ansible containers driver (Podman-backed)

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `molecule_command` | Molecule command (`test`, `converge`, `verify`, `lint`, …) | Yes | `test` |
| `molecule_options` | Global options (`--debug`, `-v`, `--base-config`, `--env-file`, …) | No | |
| `molecule_args` | Command arguments (`-s <scenario>`, `--destroy never`, `--parallel`, …) | No | |
| `molecule_working_dir` | Path within the repository to run Molecule from. Defaults to `${{ github.repository }}`, which requires the checkout `path:` to match. | No | `${{ github.repository }}` |

## Usage

### Basic

The checkout `path` must match `molecule_working_dir` so Molecule can find the role. By default both are `${{ github.repository }}`.

```yaml
jobs:
  molecule:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          path: ${{ github.repository }}
      - uses: truestory1/molecule-action@master
```

### Matrix across multiple scenarios

```yaml
jobs:
  molecule:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        scenario: [rocky8, rocky9, oracle8]
    steps:
      - uses: actions/checkout@v4
        with:
          path: ${{ github.repository }}
      - uses: truestory1/molecule-action@master
        with:
          molecule_args: --scenario-name ${{ matrix.scenario }}
```

### Run from a subdirectory (role not at repo root)

```yaml
- uses: actions/checkout@v4
- uses: truestory1/molecule-action@master
  with:
    molecule_working_dir: roles/my_role
```

### Verbose/debug output

```yaml
- uses: truestory1/molecule-action@master
  with:
    molecule_options: --debug -v
    molecule_command: converge
```

### Using the podman driver

To use the `podman` driver, start the Podman system socket on the runner and mount it into the action container:

```yaml
jobs:
  molecule:
    runs-on: ubuntu-latest
    steps:
      - name: Start Podman socket
        run: sudo systemctl start podman.socket

      - uses: actions/checkout@v4
        with:
          path: ${{ github.repository }}

      - uses: truestory1/molecule-action@master
        with:
          molecule_args: --scenario-name podman
        env:
          CONTAINER_HOST: unix:///run/podman/podman.sock
```

> **Note:** When using this action with the podman driver, pass `-v /run/podman/podman.sock:/run/podman/podman.sock` and `-e CONTAINER_HOST=unix:///run/podman/podman.sock` to the container.

## Systemd containers

For scenarios that use systemd as PID 1 (`command: /usr/sbin/init`), add `cgroupns_mode: host` to the platform in `molecule.yml` so Docker CE on cgroupsv2 hosts (ubuntu-24.04+) can properly initialize systemd:

```yaml
platforms:
  - name: instance
    image: rockylinux/rockylinux:9
    privileged: true
    command: "/usr/sbin/init"
    cgroupns_mode: host
    tmpfs:
      - /run
      - /run/lock
    volumes:
      - "/sys/fs/cgroup:/sys/fs/cgroup:rw"
```

## Building the container locally

```bash
docker build -f Containerfile -t molecule-action .
# or with podman:
podman build -f Containerfile -t molecule-action .
```

### Running locally with podman

```bash
podman run --rm \
  --security-opt label=type:spc_t \
  -v "$PWD:/workspace:z" \
  -v "$XDG_RUNTIME_DIR/podman/podman.sock:/var/run/docker.sock" \
  -w /workspace \
  -e INPUT_MOLECULE_WORKING_DIR="<role-subdir>" \
  -e INPUT_MOLECULE_COMMAND="converge" \
  -e ANSIBLE_FORCE_COLOR="1" \
  molecule-action
```
