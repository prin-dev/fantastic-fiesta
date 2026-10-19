import 'subscription_clock.dart';
import 'subscription_time_state.dart';

class SubscriptionTimeTracker {
  SubscriptionTimeTracker({
    required this._clock,
    this.checkpointInterval = const Duration(seconds: 50),
  });

  final SubscriptionClock _clock;

  /// Persist roughly every 50 seconds.
  ///
  /// This matches our earlier decision:
  /// don't write every second, but don't allow
  /// reboot manipulation to reset a large amount
  /// of subscription time either.
  final Duration checkpointInterval;

  SubscriptionTimeState? _state;

  DateTime? _lastCheckpoint;

  Duration _unsavedElapsed = Duration.zero;

  bool get initialized => _state != null;

  int get remainingSeconds => _state?.remainingSeconds ?? 0;

  Duration get remaining => Duration(seconds: remainingSeconds);

  void initialize({
    required int remainingSeconds,
    required DateTime lastCheckpoint,
  }) {
    _state = SubscriptionTimeState(
      remainingSeconds: remainingSeconds,
      lastCheckpoint: lastCheckpoint,
    );

    _lastCheckpoint = lastCheckpoint;
    _unsavedElapsed = Duration.zero;
  }

  /// Advances the subscription clock.
  ///
  /// Returns true when the state should be persisted.
  bool tick() {
    if (_state == null) {
      throw StateError('SubscriptionTimeTracker has not been initialized.');
    }

    final now = _clock.now;

    final elapsed = _clock.elapsedSince(_lastCheckpoint!);

    if (elapsed.isNegative || elapsed == Duration.zero) {
      return false;
    }

    _lastCheckpoint = now;

    _unsavedElapsed += elapsed;

    final remaining = _state!.remainingSeconds - elapsed.inSeconds;

    _state = _state!.copyWith(
      remainingSeconds: remaining.clamp(0, remaining),
      lastCheckpoint: now,
    );

    if (_unsavedElapsed >= checkpointInterval) {
      _unsavedElapsed = Duration.zero;
      return true;
    }

    return false;
  }

  /// Forces the current state to be considered
  /// persisted.
  SubscriptionTimeState checkpoint() {
    if (_state == null) {
      throw StateError('SubscriptionTimeTracker has not been initialized.');
    }

    _unsavedElapsed = Duration.zero;

    return _state!;
  }
}
