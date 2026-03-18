default:
  @just --list

build:
    podman build -t github-runner .