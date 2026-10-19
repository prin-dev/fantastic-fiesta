enum SubscriptionStatus { active, rebootGrace, readOnly }

class SubscriptionState {
  final SubscriptionStatus status;
  final int remainingSeconds;
  final int rebootGraceRemainingSeconds;
  final String? lastBootId;
  final int? lastMonotonicCheckpoint;
  final DateTime? lastBackendVerification;

  const SubscriptionState({
    required this.status,
    required this.remainingSeconds,
    required this.rebootGraceRemainingSeconds,
    this.lastBootId,
    this.lastMonotonicCheckpoint,
    this.lastBackendVerification,
  });

  factory SubscriptionState.fromJson(Map<String, dynamic> json) {
    return SubscriptionState(
      status: SubscriptionStatus.values.byName(json['status'] as String),
      remainingSeconds: json['remainingSeconds'] as int,
      rebootGraceRemainingSeconds: json['rebootGraceRemainingSeconds'] as int,
      lastBootId: json['lastBootId'] as String?,
      lastMonotonicCheckpoint: json['lastMonotonicCheckpoint'] as int?,
      lastBackendVerification: json['lastBackendVerification'] != null
          ? DateTime.parse(json['lastBackendVerification'] as String)
          : null,
    );
  } 

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    int? remainingSeconds,
    int? rebootGraceRemainingSeconds,
    String? lastBootId,
    int? lastMonotonicCheckpoint,
    DateTime? lastBackendVerification,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      rebootGraceRemainingSeconds:
          rebootGraceRemainingSeconds ?? this.rebootGraceRemainingSeconds,
      lastBootId: lastBootId ?? this.lastBootId,
      lastMonotonicCheckpoint:
          lastMonotonicCheckpoint ?? this.lastMonotonicCheckpoint,
      lastBackendVerification:
          lastBackendVerification ?? this.lastBackendVerification,
    );
  }
}

extension SubscriptionStateJson on SubscriptionState {
  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'remainingSeconds': remainingSeconds,
      'rebootGraceRemainingSeconds': rebootGraceRemainingSeconds,
      'lastBootId': lastBootId,
      'lastMonotonicCheckpoint': lastMonotonicCheckpoint,
      'lastBackendVerification': lastBackendVerification?.toIso8601String(),
    };
  }
}
