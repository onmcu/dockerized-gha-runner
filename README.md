Podman-compatible GitHub Actions Runner with Rust support.

## Usage

Build the Dockerfile
```sh
podman build -t github-runner .
```

Or use image from github:
`ghcr.io/onmcu/dockerized-gha-runner:latest`

Run with podman-compose (maybe adapt image name when using local build)
```sh
podman-compose up -d
```
