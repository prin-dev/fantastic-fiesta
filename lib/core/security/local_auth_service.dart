import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:movo/core/diagnostics/logger.dart';

import 'native_auth_service.dart';

class LocalAuthService implements NativeAuthService {
  LocalAuthService({
    LocalAuthentication? localAuthentication,
    LoggerService? logger,
  }) : _localAuthentication = localAuthentication ?? LocalAuthentication(),
       _logger = logger ?? LoggerService();

  final LocalAuthentication _localAuthentication;
  final LoggerService _logger;

  @override
  Future<bool> isAvailable() async {
    try {
      final supported = await _localAuthentication.isDeviceSupported();
      _logger.info('Native auth device supported: $supported');
      return supported;
    } catch (error, stackTrace) {
      _logger.error('Native auth availability check failed', error, stackTrace);
      return false;
    }
  }

  @override
  Future<bool> authenticate() async {
    try {
      _logger.info('Native auth prompt started');
      final authenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to access MOVO',
        biometricOnly: false,
        authMessages: [
          AndroidAuthMessages(
            signInTitle: 'Authenticate to access MOVO',
            cancelButton: 'Cancel',
          ),
          IOSAuthMessages(cancelButton: 'Cancel'),
        ],
      );
      _logger.info('Native auth prompt completed: $authenticated');
      return authenticated;
    } catch (error, stackTrace) {
      _logger.error('Native auth prompt failed', error, stackTrace);
      return false;
    }
  }

  @override
  Future<void> stopAuthentication() async {
    try {
      await _localAuthentication.stopAuthentication();
    } catch (_) {
      // Nothing to do if authentication is already stopped.
    }
  }
}
