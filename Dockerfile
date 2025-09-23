FROM docker.io/myoung34/github-runner:latest

USER root

# Install dependencies and Rust in one layer
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable \
    && /root/.cargo/bin/rustup component add clippy rustfmt \
    && /root/.cargo/bin/rustup target add x86_64-unknown-linux-musl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add Rust to PATH for all users
ENV PATH="/root/.cargo/bin:${PATH}"

