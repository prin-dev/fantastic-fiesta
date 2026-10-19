import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/src/logger.dart';

import 'package:movo/core/authentication/backend_auth_service.dart';
import 'package:movo/core/authentication/device_identity_service.dart';
import 'package:movo/core/diagnostics/logger.dart';
import 'package:movo/core/networking/dio_service.dart';

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
  group('BackendAuthService', () {
    late FakeSecureStorage storage;
    late DeviceIdentityService deviceIdentityService;
    late DioService dioService;
    late BackendAuthService authService;

    setUp(() async {
      storage = FakeSecureStorage();

      deviceIdentityService = DeviceIdentityService(secureStorage: storage);

      await deviceIdentityService.initialize();

      dioService = DioService(FakeLoggerService());

      authService = BackendAuthService(
        dioService: dioService,
        deviceIdentityService: deviceIdentityService,
      );
    });

    test('starts without a valid authentication token', () {
      expect(authService.accessToken, isNull);
      expect(authService.expiresAt, isNull);
      expect(authService.hasValidToken, isFalse);
    });

    test('authenticates using challenge and verification flow', () async {
      final identity = deviceIdentityService.identity!;

      final expiresAt = DateTime.now().add(const Duration(hours: 1));

      String? receivedDeviceId;
      String? receivedChallenge;
      String? receivedSignature;

      dioService.client.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            if (options.path == '/auth/challenge') {
              receivedDeviceId =
                  (options.data as Map<String, dynamic>)['device_id'] as String;

              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'challenge': 'server-challenge-123'},
                ),
              );

              return;
            }

            if (options.path == '/auth/verify') {
              final data = options.data as Map<String, dynamic>;

              receivedDeviceId = data['device_id'] as String;
              receivedChallenge = data['challenge'] as String;
              receivedSignature = data['signature'] as String;

              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'access_token': 'test-jwt-token',
                    'expires_at': expiresAt.toIso8601String(),
                  },
                ),
              );

              return;
            }

            handler.next(options);
          },
        ),
      );

      final result = await authService.authenticate();

      expect(result.accessToken, 'test-jwt-token');
      expect(result.expiresAt, expiresAt);

      expect(authService.accessToken, 'test-jwt-token');
      expect(authService.expiresAt, expiresAt);
      expect(authService.hasValidToken, isTrue);

      expect(receivedDeviceId, identity.deviceId);
      expect(receivedChallenge, 'server-challenge-123');
      expect(receivedSignature, isNotNull);
      expect(receivedSignature, isNotEmpty);
    });

    test('clearAuthentication removes the current token', () async {
      final expiresAt = DateTime.now().add(const Duration(hours: 1));

      dioService.client.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/challenge') {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'challenge': 'challenge'},
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
                    'expires_at': expiresAt.toIso8601String(),
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

      expect(authService.hasValidToken, isTrue);

      authService.clearAuthentication();

      expect(authService.accessToken, isNull);
      expect(authService.expiresAt, isNull);
      expect(authService.hasValidToken, isFalse);
    });

    test('expired token is not considered valid', () async {
      final expiredAt = DateTime.now().subtract(const Duration(seconds: 1));

      dioService.client.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/challenge') {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'challenge': 'challenge'},
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
                    'access_token': 'expired-token',
                    'expires_at': expiredAt.toIso8601String(),
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

      expect(authService.accessToken, 'expired-token');
      expect(authService.hasValidToken, isFalse);
    });
  });
}
