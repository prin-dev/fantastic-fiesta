import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/src/logger.dart';
import 'package:movo/core/constants/network_configuration.dart';
import 'package:movo/core/diagnostics/logger.dart';
import 'package:movo/core/networking/dio_service.dart';

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

class TestInterceptor extends Interceptor {}

void main() {
  group('DioService', () {
    late DioService service;

    setUp(() {
      service = DioService(FakeLoggerService());
    });

    test('configures the correct base URL', () {
      expect(service.client.options.baseUrl, baseUrl);
    });

    test('configures the correct timeouts', () {
      expect(
        service.client.options.connectTimeout,
        const Duration(seconds: connectionTimeout),
      );

      expect(
        service.client.options.sendTimeout,
        const Duration(seconds: sendTimeout),
      );

      expect(
        service.client.options.receiveTimeout,
        const Duration(seconds: receiveTimeout),
      );
    });

    test('configures default JSON headers', () {
      expect(service.client.options.headers['Accept'], 'application/json');

      expect(
        service.client.options.headers['Content-Type'],
        'application/json',
      );
    });

    test('allows interceptors to be added', () {
      final interceptor = TestInterceptor();

      final initialCount = service.client.interceptors.length;

      service.addInterceptor(interceptor);

      expect(service.client.interceptors.length, initialCount + 1);

      expect(service.client.interceptors, contains(interceptor));
    });
  });
}
