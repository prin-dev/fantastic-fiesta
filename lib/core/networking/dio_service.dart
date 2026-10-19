import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movo/core/constants/network_configuration.dart';
import 'package:movo/core/diagnostics/logger.dart';

class DioService {
  final Dio _dio;
  final LoggerService _loggerService;

  Dio get client => _dio;

  DioService(this._loggerService)
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: connectionTimeout),
          sendTimeout: const Duration(seconds: sendTimeout),
          receiveTimeout: const Duration(seconds: receiveTimeout),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      ) {
    _configureInterceptors();
  }

  void _configureInterceptors() {
    // _dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) {
    //       // You can add custom logic here before the request is sent
    //       return handler.next(options);
    //     },
    //     onResponse: (response, handler) {
    //       // You can add custom logic here after receiving the response
    //       return handler.next(response);
    //     },
    //     onError: (DioException error, handler) {
    //       // You can add custom error handling logic here
    //       return handler.next(error);
    //     },
    //   ),
    // );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (object) {
            // You can customize how logs are printed here
            _loggerService.debug(object.toString());
          },
        ),
      );
    }
  }

  void addInterceptor(Interceptor interceptor) {
    client.interceptors.add(interceptor);
  }
}
