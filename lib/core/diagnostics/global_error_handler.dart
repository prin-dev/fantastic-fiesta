import 'package:flutter/foundation.dart';

import 'logger.dart';

class GlobalErrorHandler {
  final LoggerService logger;

  const GlobalErrorHandler({required this.logger});

  void initialize() {
    FlutterError.onError = _handleFlutterError;

    PlatformDispatcher.instance.onError = _handlePlatformError;
  }

  void _handleFlutterError(FlutterErrorDetails details) {
    logger.error('Flutter error', details.exception, details.stack);

    FlutterError.presentError(details);
  }

  bool _handlePlatformError(Object error, StackTrace stackTrace) {
    logger.error('Unhandled platform error', error, stackTrace);

    return true;
  }
}
