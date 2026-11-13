#!/usr/bin/env bash
# Tag and push the production image to Docker Hub, then pull and run it back from the registry.
# First run:  docker login      (username + a Docker Hub access token; never save the token in the repo)
# Usage:      DOCKER_USER=your-dockerhub-username bash scripts/publish.sh
set -euo pipefail
: "${DOCKER_USER:?Set DOCKER_USER to your Docker Hub username}"
docker build -t loan-api:prod -f Dockerfile.prod .
docker tag loan-api:prod "$DOCKER_USER/loan-api:1.0.0"
docker tag loan-api:prod "$DOCKER_USER/loan-api:latest"
docker push "$DOCKER_USER/loan-api:1.0.0"
docker push "$DOCKER_USER/loan-api:latest"
echo "Published: https://hub.docker.com/r/$DOCKER_USER/loan-api/tags"

# Step 4: delete local copies, then run straight from Docker Hub
docker compose down || true
docker rmi "$DOCKER_USER/loan-api:1.0.0" "$DOCKER_USER/loan-api:latest" loan-api:prod || true
echo "Now open http://localhost:8000/docs, send POST /api/v1/predictions, and take the screenshot. Ctrl+C to stop."
docker run --rm -p 8000:8000 "$DOCKER_USER/loan-api:1.0.0"
