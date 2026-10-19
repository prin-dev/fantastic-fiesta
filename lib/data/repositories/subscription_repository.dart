import 'package:movo/data/dao/subscription_dao.dart';
import 'package:movo/data/models/subscription_state.dart';

abstract interface class ISubscriptionRepository {
  SubscriptionState? getState();

  Future<void> saveState(SubscriptionState state);

  Future<void> clearState();
}

class SubscriptionRepository implements ISubscriptionRepository {
  final SubscriptionDao _dao;

  SubscriptionRepository(this._dao);

  @override
  SubscriptionState? getState() {
    return _dao.getState();
  }

  @override
  Future<void> saveState(SubscriptionState state) {
    return _dao.saveState(state);
  }

  @override
  Future<void> clearState() async {
    return await _dao.clearState();
  }
}
