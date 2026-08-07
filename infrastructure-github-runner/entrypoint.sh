#!/bin/bash
set -euo pipefail

# entrypoint.sh

# Navigate to the runner directory
cd /home/docker/actions-runner

: "${GH_URL:?GH_URL is required}"
: "${GH_TOKEN:?GH_TOKEN is required}"
: "${GH_RUNNER_NAME:?GH_RUNNER_NAME is required}"
: "${GH_RUNNER_LABEL:?GH_RUNNER_LABEL is required}"

echo "Starting GitHub Actions Runner ${GH_RUNNER_NAME} - URL: ${GH_URL} with labels: ${GH_RUNNER_LABEL}"

# Configure and register the runner dynamically
./config.sh --url "${GH_URL}" --token "${GH_TOKEN}" --name "${GH_RUNNER_NAME}" --unattended --replace --labels "${GH_RUNNER_LABEL}"

RUNNER_PID=""
cleanup() {
    local exit_code=$?
    echo "Stopping runner and unregistering..."
    if [[ -n "${RUNNER_PID}" ]]; then
        kill -TERM "${RUNNER_PID}" 2>/dev/null || true
        wait "${RUNNER_PID}" 2>/dev/null || true
    fi
    ./config.sh remove --unattended --token "${GH_TOKEN}" || true
    exit "${exit_code}"
}

# Ensure clean unregistration on container exit/signals
trap cleanup EXIT INT TERM

# Start the runner application
./run.sh &
RUNNER_PID=$!
wait "${RUNNER_PID}"
