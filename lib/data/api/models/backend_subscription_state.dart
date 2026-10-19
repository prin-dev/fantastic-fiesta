enum BackendSubscriptionStatus { active, expired, cancelled }

class BackendSubscriptionState {
  final String subscriptionId;
  final BackendSubscriptionStatus status;
  final int allocatedSeconds;
  final int consumedSeconds;
  final DateTime serverTime;

  const BackendSubscriptionState({
    required this.subscriptionId,
    required this.status,
    required this.allocatedSeconds,
    required this.consumedSeconds,
    required this.serverTime,
  });

  factory BackendSubscriptionState.fromJson(Map<String, dynamic> json) {
    return BackendSubscriptionState(
      subscriptionId: json['subscription_id'] as String,
      status: _parseStatus(json['status'] as String),
      allocatedSeconds: json['allocated_seconds'] as int,
      consumedSeconds: json['consumed_seconds'] as int,
      serverTime: DateTime.parse(json['server_time'] as String),
    );
  }
  int get remainingSeconds =>
      (allocatedSeconds - consumedSeconds).clamp(0, allocatedSeconds);

  static BackendSubscriptionStatus _parseStatus(String value) {
    return switch (value) {
      'active' => BackendSubscriptionStatus.active,
      'expired' => BackendSubscriptionStatus.expired,
      'cancelled' => BackendSubscriptionStatus.cancelled,
      _ => throw FormatException('Unknown subscription status: $value'),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'status': _statusToString(status),
      'subscription_id': subscriptionId,
      'allocated_seconds': allocatedSeconds,
      'consumed_seconds': consumedSeconds,
      'server_time': serverTime.toIso8601String(),
    };
  }

  String _statusToString(BackendSubscriptionStatus status) {
    return switch (status) {
      BackendSubscriptionStatus.active => 'active',
      BackendSubscriptionStatus.expired => 'expired',
      BackendSubscriptionStatus.cancelled => 'cancelled',
    };
  }
}
