#!/bin/bash
set -e
cd /root/FightDFire
git fetch origin
git reset --hard origin/main
docker compose --env-file .env up -d --build
docker image prune -f
