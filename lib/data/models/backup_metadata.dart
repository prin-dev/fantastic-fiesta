enum BackupType { automatic, manual }

class BackupMetadata {
  final String id;
  final String filePath;
  final DateTime createdAt;
  final BackupType type;
  final int sizeBytes;

  const BackupMetadata({
    required this.id,
    required this.filePath,
    required this.createdAt,
    required this.type,
    required this.sizeBytes,
  });

  factory BackupMetadata.fromJson(Map<String, dynamic> json) {
    return BackupMetadata(
      id: json['id'] as String,
      filePath: json['filePath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: BackupType.values.byName(json['type'] as String),
      sizeBytes: json['sizeBytes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'createdAt': createdAt.toIso8601String(),
      'type': type.name,
      'sizeBytes': sizeBytes,
    };
  }
}
