#!/bin/bash
# Health-gated deploy for Fight D Fear staging/production-readiness branch.
set -euo pipefail

REPO_DIR="${REPO_DIR:-/root/FightDFire}"
DEPLOY_BRANCH="${DEPLOY_BRANCH:-main}"
HEALTH_URL="${HEALTH_URL:-http://127.0.0.1:8084/actuator/health}"
HEALTH_TIMEOUT_SEC="${HEALTH_TIMEOUT_SEC:-120}"
COMPOSE_FILES="${COMPOSE_FILES:--f docker-compose.yml}"

cd "$REPO_DIR"

echo "==> Fetching origin"
git fetch origin

echo "==> Checking out ${DEPLOY_BRANCH}"
git checkout "$DEPLOY_BRANCH"
git reset --hard "origin/${DEPLOY_BRANCH}"

echo "==> Building and starting containers"
# shellcheck disable=SC2086
docker compose $COMPOSE_FILES --env-file .env up -d --build

echo "==> Waiting for health at ${HEALTH_URL} (max ${HEALTH_TIMEOUT_SEC}s)"
deadline=$((SECONDS + HEALTH_TIMEOUT_SEC))
while [ "$SECONDS" -lt "$deadline" ]; do
  if curl -sf "$HEALTH_URL" >/dev/null 2>&1; then
    echo "==> Health check passed"
    docker image prune -f
    exit 0
  fi
  sleep 3
done

echo "ERROR: Health check did not pass within ${HEALTH_TIMEOUT_SEC}s" >&2
docker compose logs app --tail 80 || true
exit 1
