import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerService {
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  void debug(String log) {
    if (kDebugMode) {
      logger.d(log);
    }
  }

  void info(String log) {
    if (kDebugMode) {
      logger.i(log);
    }
  }

  void warning(String log) {
    if (kDebugMode) {
      logger.w(log);
    }
  }

  void error(String log, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      logger.e(log, error: error, stackTrace: stackTrace, time: DateTime.now());
    }
  }

  void fatal(String log, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      logger.f(log, error: error, stackTrace: stackTrace, time: DateTime.now());
    }
  }

  void verbose(String log) {
    if (kDebugMode) {
      logger.t(log);
    }
  }
}
