import 'package:movo/data/dao/backup_dao.dart';
import 'package:movo/data/models/backup_metadata.dart';

class BackupMetadataRepository {
  final BackupMetadataDao _dao;

  BackupMetadataRepository(this._dao);

  List<BackupMetadata> getAll() {
    return _dao.getAll();
  }

  Future<void> saveAll(List<BackupMetadata> metadata) async {
    return await _dao.saveAll(metadata);
  }
}
