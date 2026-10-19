import 'package:dio/dio.dart';

import '../networking/dio_service.dart';
import './models/backend_auth_result.dart';
import 'device_identity_service.dart';

class BackendAuthService {
  final DioService _dioService;
  final DeviceIdentityService _deviceIdentityService;

  String? _accessToken;
  DateTime? _expiresAt;

  BackendAuthService({
    required this._dioService,
    required this._deviceIdentityService,
  }) {
    if (!_deviceIdentityService.isInitialized) {
      throw StateError('DeviceIdentityService has not been initialized.');
    }
  }

  String? get accessToken => _accessToken;

  DateTime? get expiresAt => _expiresAt;

  bool get hasValidToken {
    final token = _accessToken;
    final expiresAt = _expiresAt;

    if (token == null || expiresAt == null) {
      return false;
    }

    return DateTime.now().isBefore(expiresAt);
  }

  Future<BackendAuthResult> authenticate() async {
    final identity =
        _deviceIdentityService.identity ??
        (throw StateError('DeviceIdentityService has not been initialized.'));

    final challengeResponse = await _dioService.client.post(
      '/auth/challenge',
      data: {'device_id': identity.deviceId},
      options: Options(extra: {'skipAuthentication': true}),
    );

    final challenge = challengeResponse.data['challenge'] as String;

    final signature = await _deviceIdentityService.signChallenge(challenge);

    final verifyResponse = await _dioService.client.post(
      '/auth/verify',
      data: {
        'device_id': identity.deviceId,
        'challenge': challenge,
        'signature': signature,
      },
      options: Options(extra: {'skipAuthentication': true}),
    );

    final data = verifyResponse.data as Map<String, dynamic>;

    final result = BackendAuthResult(
      accessToken: data['access_token'] as String,
      expiresAt: DateTime.parse(data['expires_at'] as String),
    );

    _accessToken = result.accessToken;
    _expiresAt = result.expiresAt;

    return result;
  }

  void clearAuthentication() {
    _accessToken = null;
    _expiresAt = null;
  }
}
