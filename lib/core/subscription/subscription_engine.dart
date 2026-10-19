// import 'package:movo/core/subscription/subscription_clock.dart';
import 'package:movo/data/api/models/backend_subscription_state.dart';
import 'package:movo/data/api/subscription_api.dart';
import 'package:movo/data/models/subscription_state.dart';
import 'package:movo/data/repositories/subscription_repository.dart';

import 'subscription_access.dart';

class SubscriptionEngine {
  SubscriptionEngine({
    // required this._clock,
    required this._subscriptionApi,
    required this._subscriptionRepository,
  });

  // final SubscriptionClock _clock;
  final SubscriptionApi _subscriptionApi;
  final SubscriptionRepository _subscriptionRepository;

  SubscriptionAccess _access = SubscriptionAccess.readOnly;

  SubscriptionState? _subscription;

  BackendSubscriptionState? _backendState;

  SubscriptionAccess get access => _access;

  SubscriptionState? get subscription => _subscription;

  BackendSubscriptionState? get backendState => _backendState;

  bool get canCreateOrders =>
      _access == SubscriptionAccess.active ||
      _access == SubscriptionAccess.offlineGrace;

  bool get isReadOnly => _access == SubscriptionAccess.readOnly;

  bool get isActive => _access == SubscriptionAccess.active;

  bool get isOfflineGrace => _access == SubscriptionAccess.offlineGrace;

  void initialize() {
    final localState = _subscriptionRepository.getState();

    if (localState == null) {
      _access = SubscriptionAccess.readOnly;
      return;
    }

    _subscription = localState;

    evaluate();
  }

  Future<void> refresh() async {
    final backendState = await _subscriptionApi.getSubscriptionStatus();

    await updateFromBackend(backendState);
  }

  void evaluate() {
    final subscription = _subscription;

    if (subscription == null) {
      _access = SubscriptionAccess.readOnly;
      return;
    }

    switch (subscription.status) {
      case SubscriptionStatus.active:
        if (subscription.remainingSeconds > 0) {
          _access = SubscriptionAccess.active;
        } else if (subscription.rebootGraceRemainingSeconds > 0) {
          _access = SubscriptionAccess.offlineGrace;
        } else {
          _access = SubscriptionAccess.readOnly;
        }
        break;

      case SubscriptionStatus.rebootGrace:
        if (subscription.rebootGraceRemainingSeconds > 0) {
          _access = SubscriptionAccess.offlineGrace;
        } else {
          _access = SubscriptionAccess.readOnly;
        }
        break;

      case SubscriptionStatus.readOnly:
        _access = SubscriptionAccess.readOnly;
        break;
    }
  }

  Duration get remainingSubscription {
    final subscription = _subscription;

    if (subscription == null) {
      return Duration.zero;
    }

    return Duration(seconds: subscription.remainingSeconds);
  }

  Duration get remainingRebootGrace {
    final subscription = _subscription;

    if (subscription == null) {
      return Duration.zero;
    }

    return Duration(seconds: subscription.rebootGraceRemainingSeconds);
  }

  Future<void> updateFromBackend(BackendSubscriptionState backendState) async {
    _backendState = backendState;

    final hasRemainingTime = backendState.remainingSeconds > 0;

    final state = SubscriptionState(
      status: hasRemainingTime
          ? SubscriptionStatus.active
          : SubscriptionStatus.readOnly,
      remainingSeconds: backendState.remainingSeconds,
      rebootGraceRemainingSeconds: 0,
      lastBackendVerification: backendState.serverTime,
    );

    _subscription = state;

    evaluate();

    await _subscriptionRepository.saveState(state);
  }
}
