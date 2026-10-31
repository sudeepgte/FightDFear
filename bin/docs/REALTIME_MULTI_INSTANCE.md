# Realtime Multi-Instance Strategy

**Decision (Phase 6):** Sticky sessions + REST polling fallback. **No Redis STOMP relay** in this release.

## Why

- Spring's in-process simple broker (`WebSocketConfig.enableSimpleBroker`) does not fan-out across JVMs.
- Adding Redis relay is justified only when chat/SOS realtime volume requires cross-node broadcast without stickiness.
- Payment, booking, and SOS **persistence** already use MySQL (Phase 2); realtime is best-effort with durable REST fallback.

## Nginx (2+ instances)

Use `ip_hash` on the upstream so a client's WebSocket stays on one JVM:

```nginx
upstream fightdfire_backend {
    ip_hash;
    server 127.0.0.1:8084;
    server 127.0.0.1:8085;   # add when scaling
}

location /ws-chat/ {
    proxy_pass http://fightdfire_backend;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
    proxy_read_timeout 3600s;
}

location /ws-sos/ {
    proxy_pass http://fightdfire_backend;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
    proxy_read_timeout 3600s;
}
```

See `deploy/nginx-fightdfire.conf` for the full sample.

## Client reconnect policy

1. **WebSocket first** — connect to `/ws-chat` or `/ws-sos` with JWT (SockJS).
2. **On disconnect** — exponential backoff reconnect (1s → 2s → 4s, cap 30s).
3. **Polling fallback** — if reconnect fails 3×, poll REST:
   - Direct messages: `GET /api/chat/messages?peerId={id}&since={iso8601}` every 5s
   - Module chats (doctor, funding, marketplace) already use REST; no change required.
4. **After reconnect** — call `GET /api/chat/messages?peerId={id}&since={lastMessageTime}` to backfill missed messages.

## SOS notifications

- SOS record + contact response rows are **persisted before** SMS/email (Phase 6).
- `SosAsyncNotificationService` delivers outbound notifications on the async thread pool.
- WebSocket updates (`/topic/sos-updates/user-{id}`) remain sticky-session dependent; SOS state is always readable via REST/SOS APIs.

## Limitations (documented, not hidden)

| Scenario | Behavior |
|----------|----------|
| User A on node 1 sends WS message to user B on node 2 | **May not deliver live** unless sticky routing keeps both on same node or polling fallback used |
| Admin SOS monitor WS | Sticky to one node; admin refresh/poll for cross-node gaps |
| Volunteer nearby alerts | Best-effort WS; volunteers should poll SOS list APIs |

## Future upgrade path

If cross-node realtime becomes mandatory:

1. Add Redis (or managed STOMP relay).
2. Switch `WebSocketConfig` to `enableStompBrokerRelay`.
3. Keep REST polling as offline/reconnect safety net.

No product decision required for initial production — sticky + polling is the approved path.
