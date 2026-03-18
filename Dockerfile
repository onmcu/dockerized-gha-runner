FROM docker.io/myoung34/github-runner:2.332.0-ubuntu-focal

USER root

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    libudev-dev \
    buildah \
    git-crypt \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    


# Switch to runner user and install Rust
USER runner
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable \
    && /home/runner/.cargo/bin/rustup component add clippy rustfmt \
    && /home/runner/.cargo/bin/rustup target add x86_64-unknown-linux-gnu aarch64-unknown-linux-gnu
    

# Add Rust to PATH for runner user
ENV PATH="/home/runner/.cargo/bin:${PATH}"
