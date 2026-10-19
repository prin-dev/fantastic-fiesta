import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:movo/core/export/native_download.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/data/database/connection/connection.dart';
import 'package:movo/utils/formatter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupDatabaseService {
  final AppDatabase _database;

  BackupDatabaseService(this._database);

  /// Creates a backup of the database with a timestamped filename
  /// Returns the path to the created backup file
  Future<String> createBackup() async {
    try {
      // Get the database file path
      final directory = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(directory.path, databaseName));

      if (!(await dbFile.exists())) {
        throw Exception('Database file not found');
      }

      final currentDateTime = DateTime.now();
      final filename =
          'movo_database_backup_${currentDateTime.year}-${currentDateTime.month}-${currentDateTime.day}_${timeString(currentDateTime).replaceFirst(':', '-')}.db';

      // Get backup directory (using temp directory for sharing)
      final downloadDir = await getDownloadsDirectory();
      if (downloadDir == null) {
        throw FlutterError('Unable to access downloads directory');
      }

      final backupPath = p.join(downloadDir.path, filename);

      await NativeDownloader.saveFile(
        bytes: dbFile.readAsBytesSync(),
        fileName: filename,
        mimeType: "application/octet-stream",
      );

      // Copy database file to backup location
      await dbFile.copy(backupPath);

      return backupPath;
    } catch (e) {
      throw Exception('Failed to create backup: $e');
    }
  }

  /// Shares the backup file using the device's share functionality
  Future<void> shareBackup(String backupPath) async {
    try {
      final file = File(backupPath);
      if (!await file.exists()) {
        throw Exception('Backup file not found');
      }

      final xFile = XFile(backupPath);
      await SharePlus.instance.share(
        ShareParams(
          subject: 'Movo Database Backup',
          text: 'Backup created on ${DateTime.now()}',
          files: [xFile],
        ),
      );
    } catch (e) {
      throw Exception('Failed to share backup: $e');
    }
  }

  /// Restores the database from a backup file
  /// Returns true if successful, false otherwise
  Future<bool> restoreBackup(String backupPath) async {
    try {
      final backupFile = File(backupPath);
      if (!await backupFile.exists()) {
        throw Exception('Backup file not found');
      }

      // Close database connections before replacing the file
      await _database.close();

      // Get the database file path
      final directory = await getApplicationDocumentsDirectory();
      final dbPath = p.join(directory.path, databaseName);

      // Replace current database with backup
      await backupFile.copy(dbPath);

      return true;
    } catch (e) {
      throw Exception('Failed to restore backup: $e');
    }
  }
}
