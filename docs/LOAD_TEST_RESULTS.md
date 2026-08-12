# Load Test Results — Fight D Fear

**Branch:** `cursor/production-readiness`  
**Report date:** 2026-08-12  
**Honesty note:** Full staging load runs (100/500 VU, multi-instance) were **not executed in this CI/dev environment** because k6 is not installed locally and no staging VPS was available in this session. Scripts are committed and ready to run on staging.

## What was executed locally

| Test | Command | Result |
|------|---------|--------|
| Maven unit/integration | `mvn test` | **PASS** — 17 tests, 0 failures |
| Flutter tests | `flutter test test/` | **PASS** — 3 tests |
| Compile | `mvn compile -DskipTests` | **PASS** (prior phases) |
| k6 browse 100 VU | — | **NOT RUN** — k6 not installed |
| k6 browse 500 VU | — | **NOT RUN** — requires staging |
| Multi-instance pay verify | — | **NOT RUN** — requires 2 app instances + nginx |
| Multi-instance file read | — | **NOT RUN** — requires S3 or shared storage |
| Multi-instance WebSocket | — | **NOT RUN** — requires sticky nginx + 2 nodes |

## Scripts provided (`loadtests/`)

| Script | Purpose |
|--------|---------|
| `browse.js` | Public health + landing feed; configurable `VUS`, `DURATION` |
| `login_probe.js` | Auth health + login rejection smoke |
| `payment_config.js` | Payment config reachability |
| `creator_feed.js` | Paginated creator feed (needs `AUTH_TOKEN`) |

## How to run on staging (required before production)

```bash
# Install k6: https://grafana.com/docs/k6/latest/set-up/install-k6/
export BASE_URL=https://staging.fightdfire.example.com

# Smoke (10 VU)
k6 run -e BASE_URL=$BASE_URL loadtests/browse.js

# Target 100 VU / 2 min — success criteria p95 browse < 500ms
k6 run -e BASE_URL=$BASE_URL -e VUS=100 -e DURATION=2m loadtests/browse.js

# Target 500 VU — document bottlenecks
k6 run -e BASE_URL=$BASE_URL -e VUS=500 -e DURATION=3m loadtests/browse.js
```

## Multi-instance checklist (staging)

1. Start two app containers (`8084`, `8085`) with shared MySQL + S3 (if using object storage).
2. Apply `deploy/nginx-fightdfire.conf` with `ip_hash`.
3. **Payment:** Create order on instance A, verify on instance B (DB-backed pending orders — Phase 2).
4. **Storage:** Upload on A, read URL on B (S3 or shared volume — Phase 4).
5. **Realtime:** WebSocket chat with sticky sessions; REST polling fallback per `docs/REALTIME_MULTI_INSTANCE.md`.

## Expected bottlenecks (from code review, not load-tested)

- Creator feed still filters in-memory after SQL page fetch when search/category/city filters applied.
- MySQL connection pool (Hikari max 20 in prod profile) may saturate before 500 VU.
- OTP/login rate limits (MySQL buckets) will return 429 under abuse — by design.

## Gate status

| Gate | Status |
|------|--------|
| Scripts committed | ✅ |
| 100 VU staging run | ❌ Not executed — **blocker for 10/10 score** |
| 500 VU staging run | ❌ Not executed |
| Multi-instance tests | ❌ Not executed |

Update this file with real k6 output JSON/summary after staging runs.
