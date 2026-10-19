import 'dart:convert';

import 'package:movo/core/storage/storage_service.dart';
import 'package:movo/data/models/subscription_state.dart';
import 'package:movo/core/constants/string_keys.dart';

class SubscriptionDao {
  final AppStorageService _prefs;

  SubscriptionDao(this._prefs);

  SubscriptionState? getState() {
    final json = _prefs.getString(subscriptionState);

    if (json == null) {
      return null;
    }

    return SubscriptionState.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> saveState(SubscriptionState state) {
    return _prefs.setString(subscriptionState, jsonEncode(state.toJson()));
  }

  Future<void> clearState() {
    return _prefs.remove(subscriptionState);
  }
}
