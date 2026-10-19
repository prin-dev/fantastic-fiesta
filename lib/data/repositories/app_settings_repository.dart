import 'package:movo/data/dao/app_settings_dao.dart';
import 'package:movo/data/models/app_settings.dart';

class AppSettingsRepository {
  final AppSettingsDao _dao;

  AppSettingsRepository(this._dao);

  AppSettings getSettings() {
    return _dao.getSettings();
  }

  Future<void> saveSettings(AppSettings settings) {
    return _dao.saveSettings(settings);
  }

  Future<void> clearSettings() {
    return _dao.clearSettings();
  }
}
