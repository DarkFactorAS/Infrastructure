FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install core dependencies and GitHub Runner prerequisites
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    git \
    jq \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user (GitHub runner cannot run natively as root)
RUN useradd -m docker && usermod -aG sudo docker && echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER docker
WORKDIR /home/docker

# Download and extract the GitHub Actions runner (v2.336.0 as an example)
RUN mkdir actions-runner && cd actions-runner \
    && curl -o actions-runner-linux-x64-2.336.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.336.0/actions-runner-linux-x64-2.336.0.tar.gz \
    && echo "04cf0be1aff4c3ec3554466c39124ca250e3effd8873bb7e8d68535aa9505d5d  actions-runner-linux-x64-2.336.0.tar.gz" | sha256sum -c - \
    && tar xzf ./actions-runner-linux-x64-2.336.0.tar.gz \
    && rm actions-runner-linux-x64-2.336.0.tar.gz

# Install runner OS dependencies via the included script
USER root
RUN /home/docker/actions-runner/bin/installdependencies.sh

# Copy over the entrypoint script
COPY entrypoint.sh /home/docker/entrypoint.sh
RUN chmod +x /home/docker/entrypoint.sh && chown docker:docker /home/docker/entrypoint.sh

USER docker
ENTRYPOINT ["/home/docker/entrypoint.sh"]
