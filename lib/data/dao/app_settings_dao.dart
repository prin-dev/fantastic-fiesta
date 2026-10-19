import 'dart:convert';

import 'package:movo/core/storage/storage_service.dart';
import 'package:movo/core/constants/string_keys.dart';
import 'package:movo/data/models/app_settings.dart';

class AppSettingsDao {
  final AppStorageService _prefs;

  AppSettingsDao(this._prefs);

  AppSettings getSettings() {
    final json = _prefs.getString(appSettingsKey);

    if (json == null) {
      return const AppSettings();
    }

    return AppSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> saveSettings(AppSettings settings) {
    return _prefs.setString(appSettingsKey, jsonEncode(settings.toJson()));
  }

  Future<void> clearSettings() {
    return _prefs.remove(appSettingsKey);
  }
}
