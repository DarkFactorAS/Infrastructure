#!/bin/bash
# entrypoint.sh

# Navigate to the runner directory
cd /home/docker/actions-runner

echo "Starting GitHub Actions Runner ${GH_RUNNER_NAME} - URL: ${GH_URL}"

# Configure and register the runner dynamically
./config.sh --url "${GH_URL}" --token "${GH_TOKEN}" --name "${GH_RUNNER_NAME}" --unattended --replace

# Define cleanup function to remove runner from GitHub on container exit
remove_runner() {
    echo "Stopping runner and unregistering..."
    ./config.sh remove --token "${GH_TOKEN}"
}

# Trap exit signals to ensure clean unregistration
trap 'remove_runner; exit 130' INT
trap 'remove_runner; exit 143' TERM

# Start the runner application
./run.sh & wait $!
