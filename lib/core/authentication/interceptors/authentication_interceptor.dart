import 'package:dio/dio.dart';

import '../backend_auth_service.dart';

class AuthenticationInterceptor extends Interceptor {
  final BackendAuthService _authService;

  AuthenticationInterceptor({required this._authService});
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuthentication'] == true) {
      handler.next(options);
      return;
    }

    try {
      if (!_authService.hasValidToken) {
        await _authService.authenticate();
      }

      final token = _authService.accessToken;

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options);
    } catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
          type: DioExceptionType.connectionError,
        ),
      );
    }
  }
}
