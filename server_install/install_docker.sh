#
# Docker install
#

# Remove Conflicting Packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done

# Set Up the Official Docker Repository
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://docker.com -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc


# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://docker.com
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt-get update

# Install Docker Engine
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Production Hardening & Configuration
sudo tee /etc/docker/daemon.json <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

# Enable on Boot & Apply Config: Restart Docker to load daemon.json 
# and ensure it starts automatically on reboot:
sudo systemctl enable --now docker
sudo systemctl restart docker

# Manage Non-Root Access: Add your deployment user to the docker 
# group (note: users in this
# group effectively have root-level privileges on the host):

sudo usermod -aG docker $USER
newgrp docker

# Verify Setup
sudo docker run --rm hello-world