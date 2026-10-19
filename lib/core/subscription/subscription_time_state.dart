class SubscriptionTimeState {
  const SubscriptionTimeState({
    required this.remainingSeconds,
    required this.lastCheckpoint,
  });

  final int remainingSeconds;
  final DateTime lastCheckpoint;

  SubscriptionTimeState copyWith({
    int? remainingSeconds,
    DateTime? lastCheckpoint,
  }) {
    return SubscriptionTimeState(
      remainingSeconds:
          remainingSeconds ?? this.remainingSeconds,
      lastCheckpoint:
          lastCheckpoint ?? this.lastCheckpoint,
    );
  }
}