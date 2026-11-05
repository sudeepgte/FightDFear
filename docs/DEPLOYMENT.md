# Deployment Guide — Fight D Fear

Deploy from an **empty MySQL database**. Flyway creates the schema on first boot.
Do not import an old production dump.

## Environments

| Environment | How to run | Env file | Database |
|-------------|------------|----------|----------|
| **Local** | `mvn spring-boot:run` or Docker | `application-local.properties` or `.env` | empty `womenbesafety` |
| **Staging** | `docker-compose.yml` + `docker-compose.staging.yml` | `.env` from `.env.staging.example` | empty `womenbesafety_staging` |
| **Production** | `docker-compose.yml` after staging sign-off | `.env` from `.env.example` | empty `womenbesafety` |

Set `APP_BASE_URL` to the public hostname of **this** environment. Do not hardcode old server URLs.

## Local from scratch

1. Create an empty MySQL 8 database (or let the JDBC URL create it):

```sql
CREATE DATABASE womenbesafety CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. Copy `src/main/resources/application-local.properties.example` to `application-local.properties` if you need local overrides.
3. Start the app. Flyway applies `db/migration/V1` onward automatically.

If a previous local run left a half-migrated schema, drop and recreate:

```sql
DROP DATABASE IF EXISTS womenbesafety;
CREATE DATABASE womenbesafety CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

## Staging

1. Copy `.env.staging.example` → `.env` and fill secrets (Razorpay **test** keys, mail, JWT, `APP_BASE_URL`).
2. Start from an empty database volume (do not restore an old dump).
3. Deploy:

```bash
docker compose -f docker-compose.yml -f docker-compose.staging.yml --env-file .env up -d --build
```

4. Verify health:

```bash
curl -sf http://127.0.0.1:8084/actuator/health
```

5. Point Flutter at staging:

```bash
cd mobile
flutter run --dart-define=API_BASE=https://YOUR_STAGING_DOMAIN
```

## Production

Only after staging is verified:

1. Copy `.env.example` → `.env` with live secrets.
2. Use a new empty MySQL database.
3. Set `APP_BASE_URL` and nginx `server_name` to the new production domain.
4. Start:

```bash
docker compose --env-file .env up -d --build
curl -sf http://127.0.0.1:8084/actuator/health
```

## Health-gated rollout

`deploy/deploy.sh` waits for `/actuator/health` before declaring success:

```bash
export DEPLOY_BRANCH=main
./deploy/deploy.sh
```

## Rollback

Flyway migrations are forward-only.

1. Check out the last good commit and rebuild.
2. If a bad migration shipped, restore MySQL from the pre-deploy snapshot **or** ship a new forward migration.
3. Do not edit already-applied `V*.sql` files on a live database.

## Secrets

- Never commit `.env`, Razorpay secrets, or JWT keys.
- Rotate `JWT_SECRET` if leaked; users must re-login.

## Related docs

- `docs/REALTIME_MULTI_INSTANCE.md` — WebSocket sticky sessions
- `docs/STORAGE_MIGRATION.md` — S3 migration runbook
