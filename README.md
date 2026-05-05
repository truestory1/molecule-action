# Ansible Molecule GitHub Action

A GitHub Action for running [Ansible Molecule](https://ansible.readthedocs.io/projects/molecule/) tests in your CI/CD pipelines. Runs inside a Rocky Linux 10 (UBI) container with Ansible, Molecule, and linting tools pre-installed.

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `molecule_command` | Molecule command to run (e.g. `test`, `converge`, `verify`, `lint`) | Yes | `test` |
| `molecule_options` | Global Molecule options such as `--debug`, `-v`, `--base-config`, `--env-file` | No | |
| `molecule_args` | Arguments passed to the command (e.g. `-s <scenario>`, `--driver-name docker`, `--destroy never`, `--parallel`) | No | |
| `molecule_working_dir` | Path to a subdirectory in the repository to run Molecule from. Useful when the Ansible role is not at the repository root. | No | `${{ github.repository }}` |

## Usage

### Basic — run all scenarios with `molecule test`

```yaml
- uses: truestory1/molecule-action@master
```

### Run a specific scenario

```yaml
- uses: truestory1/molecule-action@master
  with:
    molecule_command: test
    molecule_args: -s my-scenario
```

### Run from a subdirectory

```yaml
- uses: truestory1/molecule-action@master
  with:
    molecule_command: test
    molecule_working_dir: roles/my_role
```

### Verbose output with debug

```yaml
- uses: truestory1/molecule-action@master
  with:
    molecule_options: --debug -v
    molecule_command: converge
```

## Building the Container Locally

```bash
docker build -f Containerfile -t molecule-action .
```
