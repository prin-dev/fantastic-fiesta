import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/src/logger.dart';
import 'package:movo/core/connectivity/connectivity_service.dart';
import 'package:movo/core/diagnostics/logger.dart';
import 'package:movo/core/networking/dio_service.dart';

class FakeConnectivity implements ConnectivityChecker {
  List<ConnectivityResult> currentResults = [];

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return currentResults;
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    // This is a simplified implementation for testing purposes.
    // In a real-world scenario, you would have a more complex implementation.
    return Stream.value(currentResults);
  }
}

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
  group('ConnectivityService', () {
    late FakeConnectivity connectivity;
    late DioService dioService;
    late ConnectivityService service;

    setUp(() {
      connectivity = FakeConnectivity();
      dioService = DioService(FakeLoggerService());

      service = ConnectivityService(
        dioService: dioService,
        connectivity: connectivity,
      );
    });

    test('returns false when there is no network connection', () async {
      connectivity.currentResults = [ConnectivityResult.none];

      final result = await service.isInternetAvailable();

      expect(result, isFalse);
    });

    test(
      'returns true when Wi-Fi is available and backend is reachable',
      () async {
        connectivity.currentResults = [ConnectivityResult.wifi];

        dioService.client.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.resolve(
                Response(requestOptions: options, statusCode: 200),
              );
            },
          ),
        );

        final result = await service.isInternetAvailable();

        expect(result, isTrue);
      },
    );

    test(
      'returns true when mobile network is available and backend is reachable',
      () async {
        connectivity.currentResults = [ConnectivityResult.mobile];

        dioService.client.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.resolve(
                Response(requestOptions: options, statusCode: 200),
              );
            },
          ),
        );

        final result = await service.isInternetAvailable();

        expect(result, isTrue);
      },
    );

    test(
      'returns false when network exists but backend is unreachable',
      () async {
        connectivity.currentResults = [ConnectivityResult.wifi];

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

        final result = await service.isInternetAvailable();

        expect(result, isFalse);
      },
    );

    test('returns false when backend health check returns non-200', () async {
      connectivity.currentResults = [ConnectivityResult.wifi];

      dioService.client.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(Response(requestOptions: options, statusCode: 503));
          },
        ),
      );

      final result = await service.isInternetAvailable();

      expect(result, isFalse);
    });

    test(
      'treats Bluetooth alone as having no usable internet connection',
      () async {
        connectivity.currentResults = [ConnectivityResult.bluetooth];

        final result = await service.isInternetAvailable();

        expect(result, isFalse);
      },
    );
  });
}
