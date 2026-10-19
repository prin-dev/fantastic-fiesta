import 'dart:convert';

import 'package:movo/core/storage/storage_service.dart';
import 'package:movo/data/models/backup_metadata.dart';
import 'package:movo/core/constants/string_keys.dart';

class BackupMetadataDao {
  final AppStorageService _prefs;

  BackupMetadataDao(this._prefs);

  List<BackupMetadata> getAll() {
    final json = _prefs.getString(backupMetadataKey);

    if (json == null) {
      return [];
    }

    final list = jsonDecode(json) as List;

    return list
        .map((item) => BackupMetadata.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveAll(List<BackupMetadata> metadata) {
    return _prefs.setString(
      backupMetadataKey,
      jsonEncode(metadata.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> clear() {
    return _prefs.remove(backupMetadataKey);
  }
}
