import 'package:flutter_test/flutter_test.dart';
import 'package:movo/core/authentication/device_identity.dart';

void main() {
  test('Creates a DeviceIdentity with device ID and public key', () {
    // Add your test cases here

    // Arrange
    const deviceId = 'test-device-id';
    const publicKey =
        '-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA7v1Z5J6F5z5Z5J6F5z5Z\n-----END PUBLIC KEY-----';

    const deviceIdentity = DeviceIdentity(
      deviceId: deviceId,
      publicKey: publicKey,
    );
    expect(deviceIdentity.deviceId, deviceId);
    expect(deviceIdentity.publicKey, publicKey);
  });
}
