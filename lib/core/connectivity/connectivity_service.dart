import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../networking/dio_service.dart';

abstract class ConnectivityChecker {
  Future<List<ConnectivityResult>> checkConnectivity();

  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

class ConnectivityPlusChecker implements ConnectivityChecker {
  final Connectivity _connectivity;

  ConnectivityPlusChecker({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  @override
  Future<List<ConnectivityResult>> checkConnectivity() {
    return _connectivity.checkConnectivity();
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}

class ConnectivityService {
  final ConnectivityChecker _connectivity;
  final DioService _dioService;

  ConnectivityService({
    required this._dioService,
    ConnectivityChecker? connectivity,
  }) : _connectivity = connectivity ?? ConnectivityPlusChecker();

  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  Future<bool> isInternetAvailable() async {
    final results = await _connectivity.checkConnectivity();

    final hasNetwork = results.any(
      (result) => result != ConnectivityResult.none,
    );

    if (!hasNetwork) {
      return false;
    }

    try {
      final response = await _dioService.client.get(
        '/health',
        options: Options(extra: {'skipAuthentication': true}),
      );

      return response.statusCode == 200;
    } on DioException {
      return false;
    }
  }
}
