/**
 * k6 browse smoke — public landing feed + health.
 *
 * Usage:
 *   k6 run -e BASE_URL=http://127.0.0.1:8084 loadtests/browse.js
 *   k6 run -e BASE_URL=https://staging.example.com -e VUS=100 -e DURATION=2m loadtests/browse.js
 */
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE_URL = __ENV.BASE_URL || 'http://127.0.0.1:8084';
const VUS = Number(__ENV.VUS || 10);
const DURATION = __ENV.DURATION || '30s';

export const options = {
  vus: VUS,
  duration: DURATION,
  thresholds: {
    http_req_failed: ['rate<0.05'],
    http_req_duration: ['p(95)<500'],
  },
};

export default function () {
  const health = http.get(`${BASE_URL}/actuator/health`);
  check(health, { 'health status 200 or 503': (r) => r.status === 200 || r.status === 503 });

  const feed = http.get(`${BASE_URL}/api/landing/feed`);
  check(feed, {
    'landing feed 200': (r) => r.status === 200,
    'landing feed has success': (r) => {
      try {
        return JSON.parse(r.body).success === true;
      } catch {
        return false;
      }
    },
  });

  sleep(1);
}
