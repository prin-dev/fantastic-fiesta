import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movo/core/authentication/device_identity_service.dart';

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

void main() {
  group('DeviceIdentityService', () {
    late FakeSecureStorage storage;

    setUp(() {
      storage = FakeSecureStorage();
    });

    test('creates a new identity when no identity exists', () async {
      final service = DeviceIdentityService(secureStorage: storage);

      expect(service.isInitialized, isFalse);
      expect(service.identity, isNull);

      await service.initialize();

      expect(service.isInitialized, isTrue);
      expect(service.identity, isNotNull);
      expect(service.identity!.deviceId, isNotEmpty);
      expect(service.identity!.publicKey, isNotEmpty);
    });

    test('persists the generated identity', () async {
      final service = DeviceIdentityService(secureStorage: storage);

      await service.initialize();

      expect(
        await storage.read(key: 'device_identity.device_id'),
        service.identity!.deviceId,
      );

      expect(await storage.read(key: 'device_identity.private_key'), isNotNull);

      expect(
        await storage.read(key: 'device_identity.public_key'),
        service.identity!.publicKey,
      );
    });

    test(
      'restores the existing identity instead of creating a new one',
      () async {
        final firstService = DeviceIdentityService(secureStorage: storage);

        await firstService.initialize();

        final firstIdentity = firstService.identity!;

        final secondService = DeviceIdentityService(secureStorage: storage);

        await secondService.initialize();

        expect(secondService.identity, isNotNull);
        expect(secondService.identity!.deviceId, firstIdentity.deviceId);
        expect(secondService.identity!.publicKey, firstIdentity.publicKey);
      },
    );

    test('cannot sign a challenge before initialization', () async {
      final service = DeviceIdentityService(secureStorage: storage);

      expect(
        () => service.signChallenge('test-challenge'),
        throwsA(isA<StateError>()),
      );
    });

    test('signs a challenge with the device private key', () async {
      final service = DeviceIdentityService(secureStorage: storage);

      await service.initialize();

      final challenge = 'server-random-challenge';

      final signature = await service.signChallenge(challenge);

      expect(signature, isNotEmpty);

      final publicKeyBytes = base64Url.decode(service.identity!.publicKey);

      final publicKey = SimplePublicKey(
        publicKeyBytes,
        type: KeyPairType.ed25519,
      );

      final signatureBytes = base64Url.decode(signature);

      final verified = await Ed25519().verify(
        utf8.encode(challenge),
        signature: Signature(signatureBytes, publicKey: publicKey),
      );

      expect(verified, isTrue);
    });
  });
}
