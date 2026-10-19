import 'package:shared_preferences/shared_preferences.dart';

class AppStorageService {
  bool _isInitialized = false;
  late SharedPreferences _sharedPreferences;

  Future<void> initialize() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      _sharedPreferences = sharedPreferences;
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize StorageService: $e');
    }
  }

  // SharedPreferencesAsync get sharedPreferences => _sharedPreferences;

  /// Sets a string value in SharedPreferences for the given key.
  /// If the key already exists, its value will be overwritten.
  Future<void> setString(String key, String value) async {
    if (!_isInitialized) {
      throw Exception(
        'StorageService not initialized. Call initialize() first.',
      );
    }
    try {
      await _sharedPreferences.setString(key, value);
    } catch (e) {
      throw Exception('Failed to set string in SharedPreferences: $e');
    }
  }

  /// Retrieves a string value from SharedPreferences for the given key.
  /// Returns null if the key does not exist.
  String? getString(String key) {
    if (!_isInitialized) {
      throw Exception(
        'StorageService not initialized. Call initialize() first.',
      );
    }
    try {
      return _sharedPreferences.getString(key);
    } catch (e) {
      throw Exception('Failed to get string from SharedPreferences: $e');
    }
  }

  /// Sets an integer value in SharedPreferences for the given key.
  /// If the key already exists, its value will be overwritten.
  Future<void> setInt(String key, int value) async {
    if (!_isInitialized) {
      throw Exception(
        'StorageService not initialized. Call initialize() first.',
      );
    }
    try {
      await _sharedPreferences.setInt(key, value);
    } catch (e) {
      throw Exception('Failed to set integer in SharedPreferences: $e');
    }
  }

  /// Retrieves an integer value from SharedPreferences for the given key.
  /// Returns null if the key does not exist.
  int? getInt(String key) {
    if (!_isInitialized) {
      throw Exception(
        'StorageService not initialized. Call initialize() first.',
      );
    }
    try {
      return _sharedPreferences.getInt(key);
    } catch (e) {
      throw Exception('Failed to get integer from SharedPreferences: $e');
    }
  }

  /// Sets a boolean value in SharedPreferences for the given key.
  /// If the key already exists, its value will be overwritten.
  Future<void> setBool(String key, bool value) async {
    if (!_isInitialized) {
      throw Exception(
        'StorageService not initialized. Call initialize() first.',
      );
    }
    try {
      await _sharedPreferences.setBool(key, value);
    } catch (e) {
      throw Exception('Failed to set boolean in SharedPreferences: $e');
    }
  }

  /// Retrieves a boolean value from SharedPreferences for the given key.
  /// Returns null if the key does not exist.
  bool getBool(String key) {
    if (!_isInitialized) {
      throw Exception(
        'StorageService not initialized. Call initialize() first.',
      );
    }
    try {
      return _sharedPreferences.getBool(key) ?? false;
    } catch (e) {
      throw Exception('Failed to get boolean from SharedPreferences: $e');
    }
  }

  /// Removes a specific key-value pair from SharedPreferences.
  /// If the key does not exist, this method does nothing.
  Future<void> remove(String key) async {
    if (!_isInitialized) {
      throw Exception(
        'StorageService not initialized. Call initialize() first.',
      );
    }
    try {
      await _sharedPreferences.remove(key);
    } catch (e) {
      throw Exception('Failed to remove key from SharedPreferences: $e');
    }
  }

  /// Clears all data from SharedPreferences.
  /// This is destructive and should be used with caution,
  /// as it will remove all stored preferences.
  Future<void> clear() async {
    if (!_isInitialized) {
      throw Exception(
        'StorageService not initialized. Call initialize() first.',
      );
    }
    try {
      await _sharedPreferences.clear();
    } catch (e) {
      throw Exception('Failed to clear SharedPreferences: $e');
    }
  }
}
