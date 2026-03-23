FROM docker.io/myoung34/github-runner:2.332.0-ubuntu-focal

USER root

# Install system dependencies + Node.js 22
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    libudev-dev \
    buildah \
    git-crypt \
    nodejs \
    && corepack enable \
    && corepack prepare pnpm@latest --activate \
    && apt-get clean \
    && apt-get autoremove --purge -y \
    && rm -rf /var/lib/apt/lists/*

# Switch to runner user and install Rust
USER runner
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable \
    && /home/runner/.cargo/bin/rustup component add clippy rustfmt \
    && /home/runner/.cargo/bin/rustup target add x86_64-unknown-linux-gnu aarch64-unknown-linux-gnu

# Add Rust to PATH for runner user
ENV PATH="/home/runner/.cargo/bin:${PATH}"

# Install cargo-binstall via prebuilt binary (cargo install fails on Focal's GCC 9)
RUN curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash \
    && cargo binstall cargo-nextest --no-confirm --no-symlinks \
    && cargo binstall cargo-deny --no-confirm --no-symlinks \
    && cargo binstall sqlx-cli --no-confirm --no-symlinks
