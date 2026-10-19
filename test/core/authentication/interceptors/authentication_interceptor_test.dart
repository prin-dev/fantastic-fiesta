import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

import 'package:movo/core/authentication/backend_auth_service.dart';
import 'package:movo/core/authentication/device_identity_service.dart';
import 'package:movo/core/authentication/interceptors/authentication_interceptor.dart';
import 'package:movo/core/diagnostics/logger.dart';
import 'package:movo/core/networking/dio_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FakeSecureStorage extends FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<String?> read({
    required String key,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    return _storage[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    _storage[key] = value ?? '';
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
  group('AuthenticationInterceptor', () {
    late FakeSecureStorage storage;
    late DeviceIdentityService deviceIdentityService;
    late DioService dioService;
    late BackendAuthService authService;
    late AuthenticationInterceptor interceptor;

    setUp(() async {
      storage = FakeSecureStorage();

      deviceIdentityService = DeviceIdentityService(secureStorage: storage);

      await deviceIdentityService.initialize();

      dioService = DioService(FakeLoggerService());

      authService = BackendAuthService(
        dioService: dioService,
        deviceIdentityService: deviceIdentityService,
      );

      interceptor = AuthenticationInterceptor(authService: authService);
    });

    test('attaches an existing valid token', () async {
      final expiry = DateTime.now().add(const Duration(hours: 1));

      dioService.client.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/challenge') {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'challenge': 'test-challenge'},
                ),
              );
              return;
            }

            if (options.path == '/auth/verify') {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'access_token': 'test-token',
                    'expires_at': expiry.toIso8601String(),
                  },
                ),
              );
              return;
            }

            handler.next(options);
          },
        ),
      );

      await authService.authenticate();

      final options = RequestOptions(path: '/orders');

      final handler = TestRequestHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer test-token');

      expect(handler.nextCalled, isTrue);
      expect(handler.rejectCalled, isFalse);
    });

    test('authenticates when no valid token exists', () async {
      final expiry = DateTime.now().add(const Duration(hours: 1));

      var authenticationRequests = 0;

      dioService.client.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/challenge') {
              authenticationRequests++;

              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'challenge': 'test-challenge'},
                ),
              );
              return;
            }

            if (options.path == '/auth/verify') {
              authenticationRequests++;

              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'access_token': 'new-token',
                    'expires_at': expiry.toIso8601String(),
                  },
                ),
              );
              return;
            }

            handler.next(options);
          },
        ),
      );

      final options = RequestOptions(path: '/orders');

      final handler = TestRequestHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer new-token');

      expect(authenticationRequests, 2);
      expect(handler.nextCalled, isTrue);
      expect(handler.rejectCalled, isFalse);
    });

    test('bypasses authentication when skipAuthentication is true', () async {
      final options = RequestOptions(
        path: '/auth/challenge',
        extra: {'skipAuthentication': true},
      );

      final handler = TestRequestHandler();

      await interceptor.onRequest(options, handler);

      expect(handler.nextCalled, isTrue);
      expect(handler.rejectCalled, isFalse);
      expect(options.headers['Authorization'], isNull);
    });

    test('rejects request when authentication fails', () async {
      dioService.client.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/challenge') {
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.connectionError,
                  error: Exception('Backend unavailable'),
                ),
              );
              return;
            }

            handler.next(options);
          },
        ),
      );

      final options = RequestOptions(path: '/orders');

      final handler = TestRequestHandler();

      await interceptor.onRequest(options, handler);

      expect(handler.nextCalled, isFalse);
      expect(handler.rejectCalled, isTrue);
      expect(handler.rejectedException, isA<DioException>());
      expect(handler.rejectedException?.type, DioExceptionType.connectionError);
    });
  });
}

class TestRequestHandler extends RequestInterceptorHandler {
  bool nextCalled = false;
  bool rejectCalled = false;
  DioException? rejectedException;

  @override
  void next(RequestOptions request) {
    nextCalled = true;
  }

  @override
  void reject(DioException error, [bool isRedirect = false]) {
    rejectCalled = true;
    rejectedException = error;
  }
}
