import 'package:movo/core/storage/storage_service.dart';
import 'package:movo/data/database/tables/order_table.dart';

class SettingsService {
  // SharedPreferences keys
  static const String _shopNameKey = 'shop_name';
  static const String _shopPhoneKey = 'shop_phone';
  static const String _shopOwnerKey = 'shop_owner';
  static const String _shopAddressKey = 'shop_address';
  static const String _defaultPaymentMethodKey = 'default_payment_method';
  static const String _autoClearCartKey = 'auto_clear_cart';
  // static const String _appLockKey = 'app_lock';
  // static const String _appLockEnabledKey = 'app_lock_enabled';
  // static const String _inactivityTimeoutKey = 'inactivity_timeout';

  // Default values
  static const String _defaultShopName = 'My Shop';
  static const String _defaultShopOwner = 'Movo';
  static const String _defaultShopPhone = '';
  static const String _defaultShopAddress = '';
  static const PaymentMethod _defaultPaymentMethod = PaymentMethod.cash;
  // static const bool _defaultAutoClearCart = true;
  late final AppStorageService _prefs;

  SettingsService(this._prefs);

  // Shop Information
  String getShopName() {
    return _prefs.getString(_shopNameKey) ?? _defaultShopName;
  }

  Future<void> setShopName(String name) async {
    await _prefs.setString(_shopNameKey, name);
  }

  String getShopOwner() {
    return _prefs.getString(_shopOwnerKey) ?? _defaultShopOwner;
  }

  Future<void> setShopOwner(String owner) async {
    await _prefs.setString(_shopOwnerKey, owner);
  }

  String getShopPhone() {
    return _prefs.getString(_shopPhoneKey) ?? _defaultShopPhone;
  }

  Future<void> setShopPhone(String phone) async {
    await _prefs.setString(_shopPhoneKey, phone);
  }

  String getShopAddress() {
    return _prefs.getString(_shopAddressKey) ?? _defaultShopAddress;
  }

  Future<void> setShopAddress(String address) async {
    await _prefs.setString(_shopAddressKey, address);
  }

  // Application Settings
  PaymentMethod getDefaultPaymentMethod() {
    final value = _prefs.getString(_defaultPaymentMethodKey);
    if (value == null) return _defaultPaymentMethod;

    return PaymentMethod.values.firstWhere(
      (method) => method.name == value,
      orElse: () => _defaultPaymentMethod,
    );
  }

  Future<void> setDefaultPaymentMethod(PaymentMethod method) async {
    await _prefs.setString(_defaultPaymentMethodKey, method.name);
  }

  bool getAutoClearCart() {
    return _prefs.getBool(_autoClearCartKey);
  }

  Future<void> setAutoClearCart(bool enabled) async {
    await _prefs.setBool(_autoClearCartKey, enabled);
  }
}
