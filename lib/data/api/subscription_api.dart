import '../../core/networking/dio_service.dart';
import 'models/backend_subscription_state.dart';

class SubscriptionApi {
  final DioService _dioService;

  SubscriptionApi({required this._dioService});

  Future<BackendSubscriptionState> getSubscriptionStatus() async {
    final response = await _dioService.client.get('/subscription/status');

    final data = response.data as Map<String, dynamic>;

    return BackendSubscriptionState.fromJson(data);
  }
}
