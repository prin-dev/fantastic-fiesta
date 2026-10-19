import 'package:movo/core/diagnostics/logger.dart';
import 'package:logger/src/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:movo/app/lifecycle/app_lifecycle_service.dart';

class FakeLoggerService implements LoggerService {
  final List<String> messages = [];
  @override
  void debug(String message) {
    messages.add(message);
  }

  @override
  void info(String message) {
    messages.add(message);
  }

  @override
  void warning(String message) {
    messages.add(message);
  }

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    messages.add(message);
  }

  @override
  void fatal(String message, [error, StackTrace? stackTrace]) {
    messages.add(message);
  }

  @override
  Logger get logger => throw UnimplementedError();

  @override
  void verbose(String message) {
    messages.add(message);
  }
}

void main() {
  group('AppLifecycleService', () {
    late FakeLoggerService logger;

    setUp(() {
      logger = FakeLoggerService();
    });

    test('notifies lifecycle callback when state changes', () {
      AppLifecycleState? receivedState;

      final service = AppLifecycleService(
        loggerService: logger,
        onLifecycleStateChanged: (state) {
          receivedState = state;
        },
      );

      service.didChangeAppLifecycleState(AppLifecycleState.resumed);

      expect(receivedState, AppLifecycleState.resumed);
    });

    test('calls onAppResumed when app resumes', () {
      var resumed = false;

      final service = AppLifecycleService(
        loggerService: logger,
        onLifecycleStateChanged: (state) {
          if (state == AppLifecycleState.resumed) {
            resumed = true;
          }
        },
      );

      service.didChangeAppLifecycleState(AppLifecycleState.resumed);

      expect(resumed, isTrue);
    });

    test('calls onAppPaused when app is paused', () {
      var paused = false;

      final service = AppLifecycleService(
        loggerService: logger,
        onLifecycleStateChanged: (state) {
          if (state == AppLifecycleState.paused) {
            paused = true;
          }
        },
      );

      service.didChangeAppLifecycleState(AppLifecycleState.paused);

      expect(paused, isTrue);
    });

    test('does not call resume callback for paused state', () {
      var resumed = false;

      final service = AppLifecycleService(
        loggerService: logger,
        onLifecycleStateChanged: (state) {
          if (state == AppLifecycleState.resumed) {
            resumed = true;
          }
        },
      );

      service.didChangeAppLifecycleState(AppLifecycleState.paused);

      expect(resumed, isFalse);
    });

    test('logs lifecycle changes', () {
      final service = AppLifecycleService(loggerService: logger);

      service.didChangeAppLifecycleState(AppLifecycleState.resumed);

      expect(
        logger.messages,
        contains('AppLifecycleState changed: AppLifecycleState.resumed'),
      );

      expect(logger.messages, contains('App has resumed from the background'));
    });
  });
}
