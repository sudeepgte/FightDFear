/**
 * k6 creator hub feed — requires valid JWT in AUTH_TOKEN env var.
 *
 * Usage:
 *   k6 run -e BASE_URL=http://127.0.0.1:8084 -e AUTH_TOKEN=<jwt> loadtests/creator_feed.js
 */
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE_URL = __ENV.BASE_URL || 'http://127.0.0.1:8084';
const AUTH_TOKEN = __ENV.AUTH_TOKEN || '';

export const options = {
  vus: Number(__ENV.VUS || 10),
  duration: __ENV.DURATION || '30s',
  thresholds: {
    http_req_duration: ['p(95)<800'],
  },
};

export default function () {
  if (!AUTH_TOKEN) {
    console.warn('AUTH_TOKEN not set — skipping authenticated feed test');
    return;
  }
  const res = http.get(`${BASE_URL}/api/creator-hub/feed?page=0&size=20`, {
    headers: {
      Authorization: `Bearer ${AUTH_TOKEN}`,
      Accept: 'application/json',
    },
  });
  check(res, {
    'creator feed 200': (r) => r.status === 200,
  });
  sleep(1);
}
