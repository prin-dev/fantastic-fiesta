import 'package:flutter/widgets.dart';
import 'package:movo/core/diagnostics/logger.dart';

class AppLifecycleService with WidgetsBindingObserver {
  final LoggerService loggerService;

  void Function(AppLifecycleState state)? onLifecycleStateChanged;
  List<VoidCallback> onAppResumed = [];
  List<VoidCallback> onAppPaused = [];

  AppLifecycleService({
    required this.loggerService,
    this.onLifecycleStateChanged,
    // this.onAppResumed,
    // this.onAppPaused,
  });

  void addMethodToHandleLifecycleChanges({
    void Function(AppLifecycleState state)? onLifecycleStateChanged,
    VoidCallback? onAppResumed,
    VoidCallback? onAppPaused,
  }) {
    if (onLifecycleStateChanged != null) {
      this.onLifecycleStateChanged = onLifecycleStateChanged;
    }
    if (onAppResumed != null) {
      this.onAppResumed.add(onAppResumed);
    }
    if (onAppPaused != null) {
      this.onAppPaused.add(onAppPaused);
    }
  }

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    loggerService.info('AppLifecycleState changed: $state');

    // Call the callback function if provided
    onLifecycleStateChanged?.call(state);

    switch (state) {
      case AppLifecycleState.resumed:
        for (var callback in onAppResumed) {
          callback();
        }
        loggerService.info('App has resumed from the background');
        break;
      case AppLifecycleState.paused:
        for (var callback in onAppPaused) {
          callback();
        }
        loggerService.info('App has gone to the background');
        break;
      default:
        loggerService.info('AppLifecycleState is now: $state');
        break;
    }
  }
}
