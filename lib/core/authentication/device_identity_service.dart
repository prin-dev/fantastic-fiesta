import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import 'device_identity.dart';

class DeviceIdentityService {
  static const _deviceIdKey = 'device_identity.device_id';
  static const _privateKeyKey = 'device_identity.private_key';
  static const _publicKeyKey = 'device_identity.public_key';

  final FlutterSecureStorage _secureStorage;
  final Uuid _uuid;
  final Ed25519 _algorithm;

  SimpleKeyPair? _keyPair;
  DeviceIdentity? _identity;

  DeviceIdentityService({
    FlutterSecureStorage? secureStorage,
    Uuid? uuid,
    Ed25519? algorithm,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _uuid = uuid ?? const Uuid(),
       _algorithm = algorithm ?? Ed25519();

  DeviceIdentity? get identity => _identity;

  bool get isInitialized => _identity != null && _keyPair != null;

  Future<void> initialize() async {
    final existingDeviceId = await _secureStorage.read(key: _deviceIdKey);

    final existingPrivateKey = await _secureStorage.read(key: _privateKeyKey);

    final existingPublicKey = await _secureStorage.read(key: _publicKeyKey);

    if (existingDeviceId != null &&
        existingPrivateKey != null &&
        existingPublicKey != null) {
      _keyPair = await _algorithm.newKeyPairFromSeed(
        base64Url.decode(existingPrivateKey),
      );

      _identity = DeviceIdentity(
        deviceId: existingDeviceId,
        publicKey: existingPublicKey,
      );

      return;
    }

    await _createIdentity();
  }

  Future<void> _createIdentity() async {
    final deviceId = _uuid.v4();
    final keyPair = await _algorithm.newKeyPair();

    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
    final publicKey = await keyPair.extractPublicKey();

    final privateKeyEncoded = base64UrlEncode(privateKeyBytes);

    final publicKeyEncoded = base64UrlEncode(publicKey.bytes);

    await _secureStorage.write(key: _deviceIdKey, value: deviceId);

    await _secureStorage.write(key: _privateKeyKey, value: privateKeyEncoded);

    await _secureStorage.write(key: _publicKeyKey, value: publicKeyEncoded);

    _keyPair = keyPair;

    _identity = DeviceIdentity(deviceId: deviceId, publicKey: publicKeyEncoded);
  }

  Future<String> signChallenge(String challenge) async {
    if (!isInitialized) {
      throw StateError('DeviceIdentityService has not been initialized.');
    }

    final keyPair =
        _keyPair ?? (throw StateError('Key pair is not available.'));

    final signature = await _algorithm.sign(
      utf8.encode(challenge),
      keyPair: keyPair,
    );

    return base64UrlEncode(signature.bytes);
  }
}
