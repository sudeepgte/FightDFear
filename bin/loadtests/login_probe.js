/**
 * k6 auth health + rate-limit probe (no credentials — expects 400/401 on login without body).
 *
 * Usage:
 *   k6 run -e BASE_URL=http://127.0.0.1:8084 loadtests/login_probe.js
 */
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE_URL = __ENV.BASE_URL || 'http://127.0.0.1:8084';

export const options = {
  vus: 5,
  duration: '20s',
  thresholds: {
    http_req_failed: ['rate<0.2'],
  },
};

export default function () {
  const health = http.get(`${BASE_URL}/api/auth/health`);
  check(health, { 'auth health ok': (r) => r.status === 200 });

  const login = http.post(
    `${BASE_URL}/api/auth/login`,
    JSON.stringify({ email: 'probe@example.com', password: 'wrong' }),
    { headers: { 'Content-Type': 'application/json' } },
  );
  check(login, {
    'login rejects bad creds': (r) => r.status === 401 || r.status === 400,
  });

  sleep(0.5);
}
