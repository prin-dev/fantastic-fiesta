class AppSettings {
  final String? shopName;
  final String? shopOwner;
  // final String? shopAddress;
  // final String? shopContact;
  // final String? shopEmail;
  // final String? shopLogoUrl;
  // final String? shopCurrency;
  // final String? shopTimezone;
  // final String? shopLanguage;
  // final String? shopTheme;
  final bool appLockEnabled;
  final int inactivityTimeoutSeconds;

  const AppSettings({
    this.shopName,
    this.shopOwner,
    this.appLockEnabled = false,
    this.inactivityTimeoutSeconds = 300,
  });

  AppSettings copyWith({
    String? shopName,
    String? shopOwner,
    String? shopLogoUrl,
    bool? appLockEnabled,
    int? inactivityTimeoutSeconds,
  }) {
    return AppSettings(
      shopName: shopName ?? this.shopName,
      shopOwner: shopOwner ?? this.shopOwner,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      inactivityTimeoutSeconds:
          inactivityTimeoutSeconds ?? this.inactivityTimeoutSeconds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopName': shopName,
      'shopOwner': shopOwner,
      'appLockEnabled': appLockEnabled,
      'inactivityTimeoutSeconds': inactivityTimeoutSeconds,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      shopName: json['shopName'] as String?,
      shopOwner: json['shopOwner'] as String?,
      appLockEnabled: json['appLockEnabled'] as bool? ?? false,
      inactivityTimeoutSeconds: json['inactivityTimeoutSeconds'] as int? ?? 300,
    );
  }
}
