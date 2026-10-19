
abstract interface class SubscriptionClock {
  DateTime get now;

  /// Returns the elapsed duration since the previous
  /// persisted checkpoint.
  Duration elapsedSince(DateTime timestamp);
}

class SystemSubscriptionClock implements SubscriptionClock {
  const SystemSubscriptionClock();

  @override
  DateTime get now => DateTime.now();

  @override
  Duration elapsedSince(DateTime timestamp) {
    final elapsed = now.difference(timestamp);

    if (elapsed.isNegative) {
      return Duration.zero;
    }

    return elapsed;
  }
}