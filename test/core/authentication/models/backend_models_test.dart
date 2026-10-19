import 'package:flutter_test/flutter_test.dart';

import 'package:movo/core/authentication/models/backend_auth_result.dart';
import 'package:movo/data/api/models/backend_subscription_state.dart';

void main() {
  group('BackendAuthResult', () {
    test('stores access token and expiry time', () {
      final expiresAt = DateTime.utc(2026, 9, 13, 20);

      final result = BackendAuthResult(
        accessToken: 'test-token',
        expiresAt: expiresAt,
      );

      expect(result.accessToken, 'test-token');
      expect(result.expiresAt, expiresAt);
    });
  });

  group('BackendSubscriptionState', () {
    test('creates an active subscription from JSON', () {
      final json = {
        'subscription_id': 'sub_123',
        'status': 'active',
        'allocated_seconds': 720 * 60 * 60,
        'consumed_seconds': 1000,
        'server_time': '2026-09-13T13:30:00Z',
      };

      final state = BackendSubscriptionState.fromJson(json);

      expect(state.subscriptionId, 'sub_123');
      expect(state.status, BackendSubscriptionStatus.active);
      expect(state.allocatedSeconds, 2592000);
      expect(state.consumedSeconds, 1000);
      expect(state.serverTime, DateTime.parse('2026-09-13T13:30:00Z'));
    });

    test('calculates remaining seconds correctly', () {
      final state = BackendSubscriptionState(
        subscriptionId: 'sub_123',
        status: BackendSubscriptionStatus.active,
        allocatedSeconds: 7200,
        consumedSeconds: 1800,
        serverTime: DateTime.utc(2026, 9, 13),
      );

      expect(state.remainingSeconds, 5400);
    });

    test('remaining seconds never becomes negative', () {
      final state = BackendSubscriptionState(
        subscriptionId: 'sub_123',
        status: BackendSubscriptionStatus.active,
        allocatedSeconds: 7200,
        consumedSeconds: 9000,
        serverTime: DateTime.utc(2026, 9, 13),
      );

      expect(state.remainingSeconds, 0);
    });

    test('converts subscription state to JSON', () {
      final state = BackendSubscriptionState(
        subscriptionId: 'sub_123',
        status: BackendSubscriptionStatus.cancelled,
        allocatedSeconds: 7200,
        consumedSeconds: 3000,
        serverTime: DateTime.utc(2026, 9, 13, 13, 30),
      );

      final json = state.toJson();

      expect(json['subscription_id'], 'sub_123');
      expect(json['status'], 'cancelled');
      expect(json['allocated_seconds'], 7200);
      expect(json['consumed_seconds'], 3000);
      expect(json['server_time'], '2026-09-13T13:30:00.000Z');
    });

    test('supports all subscription statuses', () {
      for (final status in ['active', 'expired', 'cancelled']) {
        final state = BackendSubscriptionState.fromJson({
          'subscription_id': 'sub_123',
          'status': status,
          'allocated_seconds': 7200,
          'consumed_seconds': 100,
          'server_time': '2026-09-13T13:30:00Z',
        });

        expect(state.status.name, status);
      }
    });

    test('throws FormatException for an unknown status', () {
      expect(
        () => BackendSubscriptionState.fromJson({
          'subscription_id': 'sub_123',
          'status': 'something_else',
          'allocated_seconds': 7200,
          'consumed_seconds': 100,
          'server_time': '2026-09-13T13:30:00Z',
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
