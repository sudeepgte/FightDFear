# Multi-instance verification checklist

Run on staging with two Spring Boot instances behind nginx (`deploy/nginx-fightdfire.conf`).

## Payment cross-node (Phase 2)

1. Point mobile/client at load balancer URL.
2. `POST /payment/create-order` (sticky not required — state in MySQL).
3. Complete Razorpay test payment.
4. `POST /payment/verify` — repeat 3×; expect single fulfillment (`payment_fulfillments`).

## Storage cross-node (Phase 4)

1. Set `STORAGE_TYPE=s3` with shared bucket on both instances.
2. Upload profile image on instance A.
3. `GET` same URL from instance B.

## Realtime (Phase 6)

1. Connect WebSocket with sticky `ip_hash`.
2. Send chat message; receiver on same sticky route gets WS event.
3. Disable WS; poll `GET /api/chat/messages?peerId=&since=` every 5s.

## Record results

Paste command output and timestamps into `docs/LOAD_TEST_RESULTS.md`.
