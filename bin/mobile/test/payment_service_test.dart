import 'package:flutter_test/flutter_test.dart';

/// Mirrors PaymentService.verifyWithRetry for isolated unit testing.
Future<Map<String, dynamic>> verifyWithRetryHelper(
  Future<Map<String, dynamic>> Function() verifyFn, {
  int maxAttempts = 3,
}) async {
  Object? lastError;
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      final result = await verifyFn();
      if (result['error'] == null || attempt == maxAttempts - 1) {
        return result;
      }
      lastError = result['error'];
    } catch (e) {
      lastError = e;
      if (attempt == maxAttempts - 1) rethrow;
    }
    await Future<void>.delayed(Duration(milliseconds: 10 * (attempt + 1)));
  }
  return {'error': lastError?.toString() ?? 'Payment verification failed'};
}

void main() {
  test('retry helper recovers from transient failure', () async {
    var attempts = 0;
    final result = await verifyWithRetryHelper(() async {
      attempts++;
      if (attempts == 1) {
        throw Exception('network blip');
      }
      return {'status': 'success'};
    });
    expect(result['status'], 'success');
    expect(attempts, 2);
  });

  test('retry helper returns last error after max attempts', () async {
    final result = await verifyWithRetryHelper(() async {
      return {'error': 'still pending'};
    }, maxAttempts: 2);
    expect(result['error'], 'still pending');
  });
}
