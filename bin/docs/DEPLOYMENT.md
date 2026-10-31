# Deployment Guide — Fight D Fear

## Environments

| Environment | Branch | Compose | Env file |
|-------------|--------|---------|----------|
| **Local dev** | any | `docker compose` optional | `.env` from `.env.example` |
| **Staging** | `cursor/production-readiness` | `docker-compose.yml` + `docker-compose.staging.yml` | `.env` from `.env.staging.example` |
| **Production** | tagged release on `main` (after review) | `docker-compose.yml` | `.env` (never commit) |

## Staging bootstrap

1. Copy `.env.staging.example` → `.env` on the staging VPS.
2. Fill Razorpay **test** keys, mail, JWT secret, and `APP_BASE_URL`.
3. Deploy:

```bash
cd /root/FightDFire
git fetch origin
git checkout cursor/production-readiness
git pull origin cursor/production-readiness
docker compose -f docker-compose.yml -f docker-compose.staging.yml --env-file .env up -d --build
```

4. Verify health:

```bash
curl -sf http://127.0.0.1:8084/actuator/health | head
```

5. Flyway migrations run automatically on boot (`spring.jpa.hibernate.ddl-auto=validate` in prod profile).

## Health-gated rollout

`deploy/deploy.sh` waits for `/actuator/health` before declaring success:

```bash
export DEPLOY_BRANCH=cursor/production-readiness
./deploy/deploy.sh
```

The script:

1. Fetches and checks out `DEPLOY_BRANCH` (default: `cursor/production-readiness`).
2. Runs `docker compose up -d --build`.
3. Polls `http://127.0.0.1:8084/actuator/health` for up to 120s.
4. Exits non-zero if health never becomes UP.

## Rollback procedure

1. **Identify last good commit:**

```bash
git log --oneline -5
```

2. **Check out previous commit or tag:**

```bash
git checkout <good-sha>
docker compose --env-file .env up -d --build
```

3. **Verify health** (same curl as above).

4. **Database:** Flyway migrations are forward-only. If a bad migration shipped:
   - Restore MySQL from the latest pre-deploy snapshot, **or**
   - Ship a corrective forward migration (preferred).

5. **Re-pin branch** after hotfix:

```bash
git checkout cursor/production-readiness
git reset --hard <good-sha>   # only on staging; coordinate before production
```

## Razorpay sandbox end-to-end (staging)

1. Use dashboard **Test Mode** keys in `.env`.
2. Configure webhook URL: `https://<staging-host>/payment/webhook/razorpay`
3. Set `RAZORPAY_WEBHOOK_SECRET` to match dashboard.
4. Flutter against staging:

```bash
cd mobile
flutter run --dart-define=API_BASE_URL=https://staging.fightdfire.example.com
```

5. Complete a test payment; verify `/payment/verify` returns success and booking/enrollment row is created.

## Multi-instance staging (optional)

1. Run two app containers on ports 8084 and 8085 (duplicate `app` service or second compose project).
2. Apply `deploy/nginx-fightdfire.conf` (`ip_hash` upstream).
3. Run multi-instance checks from Phase 11 load test doc.

## Secrets

- Never commit `.env`, Razorpay secrets, or JWT keys.
- Rotate `JWT_SECRET` if leaked; users must re-login (30-day token expiry).

## Related docs

- `docs/REALTIME_MULTI_INSTANCE.md` — WebSocket sticky sessions + polling fallback
- `docs/STORAGE_MIGRATION.md` — S3 migration runbook
- `docs/LOAD_TEST_RESULTS.md` — load/concurrency evidence (Phase 11)
