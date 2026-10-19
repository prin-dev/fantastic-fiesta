import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/src/logger.dart';

import 'package:movo/core/diagnostics/logger.dart';
import 'package:movo/core/networking/dio_service.dart';
import 'package:movo/data/api/models/backend_subscription_state.dart';
import 'package:movo/data/api/subscription_api.dart';

class FakeLoggerService implements LoggerService {
  final List<String> messages = [];
  @override
  void debug(String message) {
    messages.add(message);
  }

  @override
  void info(String message) {
    messages.add(message);
  }

  @override
  void warning(String message) {
    messages.add(message);
  }

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    messages.add(message);
  }

  @override
  void fatal(String message, [error, StackTrace? stackTrace]) {
    messages.add(message);
  }

  @override
  Logger get logger => throw UnimplementedError();

  @override
  void verbose(String message) {
    messages.add(message);
  }
}

void main() {
  group('SubscriptionApi', () {
    late DioService dioService;
    late SubscriptionApi api;

    setUp(() {
      dioService = DioService(FakeLoggerService());

      api = SubscriptionApi(dioService: dioService);
    });

    test('requests subscription status from the correct endpoint', () async {
      String? requestedPath;

      dioService.client.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requestedPath = options.path;

            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'subscription_id': 'sub_123',
                  'status': 'active',
                  'allocated_seconds': 7200,
                  'consumed_seconds': 1000,
                  'server_time': '2026-09-13T13:30:00Z',
                },
              ),
            );
          },
        ),
      );

      await api.getSubscriptionStatus();

      expect(requestedPath, '/subscription/status');
    });

    test('parses backend response into BackendSubscriptionState', () async {
      dioService.client.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'subscription_id': 'sub_123',
                  'status': 'active',
                  'allocated_seconds': 7200,
                  'consumed_seconds': 1000,
                  'server_time': '2026-09-13T13:30:00Z',
                },
              ),
            );
          },
        ),
      );

      final result = await api.getSubscriptionStatus();

      expect(result, isA<BackendSubscriptionState>());
      expect(result.subscriptionId, 'sub_123');
      expect(result.status, BackendSubscriptionStatus.active);
      expect(result.allocatedSeconds, 7200);
      expect(result.consumedSeconds, 1000);
      expect(result.remainingSeconds, 6200);
      expect(result.serverTime, DateTime.parse('2026-09-13T13:30:00Z'));
    });

    test('throws FormatException for invalid subscription status', () async {
      dioService.client.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'subscription_id': 'sub_123',
                  'status': 'invalid_status',
                  'allocated_seconds': 7200,
                  'consumed_seconds': 1000,
                  'server_time': '2026-09-13T13:30:00Z',
                },
              ),
            );
          },
        ),
      );

      expect(api.getSubscriptionStatus, throwsA(isA<FormatException>()));
    });

    test('propagates DioException when backend request fails', () async {
      dioService.client.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                error: Exception('Backend unavailable'),
              ),
            );
          },
        ),
      );

      expect(api.getSubscriptionStatus, throwsA(isA<DioException>()));
    });
  });
}
