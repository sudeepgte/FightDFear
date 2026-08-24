/**
 * k6 payment config probe — read-only public payment config endpoint.
 * Does not create real orders (requires auth + session for create-order).
 */
import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE_URL = __ENV.BASE_URL || 'http://127.0.0.1:8084';

export const options = {
  vus: Number(__ENV.VUS || 5),
  duration: __ENV.DURATION || '20s',
};

export default function () {
  const res = http.get(`${BASE_URL}/payment/config`);
  check(res, {
    'payment config reachable': (r) => r.status === 200 || r.status === 302,
  });
  sleep(1);
}
