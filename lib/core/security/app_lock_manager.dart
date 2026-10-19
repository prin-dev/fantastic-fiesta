import 'package:flutter/foundation.dart';
import 'package:movo/core/diagnostics/logger.dart';
import 'package:movo/core/storage/storage_service.dart';

import 'app_lock_state.dart';
import 'native_auth_service.dart';

int _inactivityTimeoutSeconds = 30;

class AppLockManager extends ChangeNotifier {
  AppLockManager({
    required this._authService,
    required this._storageService,
    required this._logger,
  });

  final NativeAuthService _authService;
  final AppStorageService _storageService;
  final LoggerService _logger;

  bool _appLockEnabled = false;
  // Default inactivity timeout is set to 300 seconds (5 minutes)
  Duration _inactivityTimeout = Duration(seconds: _inactivityTimeoutSeconds);

  AppLockState _state = AppLockState.unlocked;

  bool get appLockEnabled => _appLockEnabled;
  Duration get inactivityTimeout => _inactivityTimeout;

  AppLockState get state => _state;

  bool get isLocked => _state == AppLockState.locked;

  bool get isAuthenticating => _state == AppLockState.authenticating;

  DateTime? _lastInteractionAt;

  Future<bool> get isDeviceSecure async => await _authService.isAvailable();

  Future<void> initialize() async {
    _appLockEnabled = _storageService.getBool('appLockEnabled');

    final timeoutSeconds =
        _storageService.getInt('inactivityTimeout') ??
        _inactivityTimeoutSeconds;

    _inactivityTimeout = Duration(seconds: timeoutSeconds);

    _logger.info(
      'AppLock initialize: enabled=$_appLockEnabled, '
      'timeout=${_inactivityTimeout.inSeconds}s, state=$_state',
    );

    notifyListeners();
  }

  void recordInteraction() {
    if (!_appLockEnabled) {
      _logger.debug('AppLock interaction ignored: app lock disabled');
      return;
    }

    _lastInteractionAt = DateTime.now();
    _logger.info('AppLock interaction recorded at $_lastInteractionAt');
  }

  void evaluateInactivity() {
    _logger.info(
      'AppLock evaluate: enabled=$_appLockEnabled, state=$_state, '
      'lastInteraction=$_lastInteractionAt',
    );

    if (!_appLockEnabled || _lastInteractionAt == null) {
      _logger.debug('AppLock evaluate skipped: not enabled or no interaction');
      return;
    }
    if (isAuthenticating) {
      _logger.debug('AppLock evaluate skipped: authentication in progress');
      return;
    }
    if (isLocked) {
      _logger.debug('AppLock evaluate skipped: already locked');
      return;
    }

    final elapsed = DateTime.now().difference(_lastInteractionAt!);
    _logger.info(
      'AppLock elapsed=${elapsed.inMilliseconds}ms, '
      'timeout=${_inactivityTimeout.inMilliseconds}ms',
    );

    if (elapsed >= _inactivityTimeout) {
      lock();
    }
  }

  Future<void> setAppLockEnabled(bool enabled) async {
    if (enabled) {
      final available = await _authService.isAvailable();

      if (!available) {
        return;
      }
    }

    _appLockEnabled = enabled;

    await _storageService.setBool('appLockEnabled', enabled);

    notifyListeners();
  }

  Future<void> setInactivityTimeout(Duration timeout) async {
    _inactivityTimeout = timeout;

    await _storageService.setInt('inactivityTimeout', timeout.inSeconds);

    notifyListeners();
  }

  void lock() {
    if (isLocked) {
      _logger.debug('AppLock lock ignored: already locked');
      return;
    }

    _logger.warning('AppLock locking from state=$_state');
    _logger.error('AppLock lock caller', null, StackTrace.current);
    _state = AppLockState.locked;
    notifyListeners();
  }

  Future<bool> unlock() async {
    _logger.info('AppLock unlock requested: state=$_state');

    // if (!isLocked) {
    //   return false;
    // }

    if (_state == AppLockState.unlocked) {
      _logger.debug('AppLock unlock ignored: already unlocked');
      return true;
    }

    if (_state == AppLockState.authenticating) {
      _logger.debug(
        'AppLock unlock ignored: authentication already in progress',
      );
      return false;
    }

    _state = AppLockState.authenticating;
    _logger.info('AppLock state changed to authenticating');
    notifyListeners();

    final authenticated = await _authService.authenticate();
    _logger.info('AppLock native authentication result: $authenticated');

    if (authenticated) {
      _state = AppLockState.unlocked;
      _lastInteractionAt = DateTime.now();
      _logger.info(
        'AppLock unlocked at $_lastInteractionAt; '
        'state=$_state',
      );
    } else {
      _state = AppLockState.locked;
      _logger.warning('AppLock authentication failed; state=$_state');
    }

    notifyListeners();

    return authenticated;
  }
}
