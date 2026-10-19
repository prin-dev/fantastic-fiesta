import 'package:movo/app/dependencies/app_dependencies.dart';
import 'package:movo/app/lifecycle/app_lifecycle_service.dart';
import 'package:movo/app/settings/settings_service.dart';
import 'package:movo/core/authentication/backend_auth_service.dart';
import 'package:movo/core/authentication/device_identity_service.dart';
import 'package:movo/core/authentication/interceptors/authentication_interceptor.dart';
import 'package:movo/core/backup/backup_service.dart';
import 'package:movo/core/connectivity/connectivity_service.dart';
import 'package:movo/core/diagnostics/global_error_handler.dart';
import 'package:movo/core/diagnostics/logger.dart';
import 'package:movo/core/export/excel_exporter.dart';
import 'package:movo/core/networking/dio_service.dart';
import 'package:movo/core/permissions/storage_permission_service.dart';
// import 'package:movo/core/security/app_lock_manager.dart';
// import 'package:movo/core/security/local_auth_service.dart';
import 'package:movo/core/storage/storage_service.dart';
import 'package:movo/data/dao/app_settings_dao.dart';
import 'package:movo/data/dao/backup_dao.dart';
import 'package:movo/data/dao/menu_item_dao.dart';
import 'package:movo/data/dao/order_dao.dart';
import 'package:movo/data/dao/order_item_dao.dart';
import 'package:movo/data/dao/subscription_dao.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/data/repositories/app_settings_repository.dart';
import 'package:movo/data/repositories/backup_metadata_repository.dart';
import 'package:movo/data/repositories/menu_repository.dart';
import 'package:movo/data/repositories/order_repository.dart';
import 'package:movo/data/repositories/subscription_repository.dart';
import 'package:movo/features/settings/avatar_service.dart';

class AppBootstrap {
  const AppBootstrap();

  Future<AppDependencies> initialize() async {
    final database = AppDatabase();
    final appStorageService = AppStorageService();
    final loggerService = LoggerService();
    final globalErrorHandler = GlobalErrorHandler(logger: loggerService);
    final appLifecycleService = AppLifecycleService(
      loggerService: loggerService,
    );
    final deviceIdentityService = DeviceIdentityService();

    // Initialize the device identity service to ensure that the device has a unique identifier and public key for authentication purposes.
    await deviceIdentityService.initialize();

    // Initialize the app storage service to manage persistent storage for settings, subscriptions, and backup metadata.
    await appStorageService.initialize();

    // Network and connectivity services
    final dio = DioService(loggerService);
    final connectivityService = ConnectivityService(dioService: dio);

    final backendAuthService = BackendAuthService(
      dioService: dio,
      deviceIdentityService: deviceIdentityService,
    );

    // Initialize DAOs for menu items and orders
    final menuDao = MenuDao(database);
    final orderDao = OrderDao(database);
    final orderItemDao = OrderItemDao(database);
    // final cartDraftDao = CartDraftDao(database);

    // Initialize DAOs for app settings, subscriptions, and backup metadata
    final appSettingsDao = AppSettingsDao(appStorageService);
    final subscriptionDao = SubscriptionDao(appStorageService);
    final backupMetadataDao = BackupMetadataDao(appStorageService);

    final authenticationInterceptor = AuthenticationInterceptor(
      authService: backendAuthService,
    );
    dio.addInterceptor(authenticationInterceptor);

    globalErrorHandler.initialize();

    final excelExportService = ExcelExportService(loggerService: loggerService);

    final backupDatabaseService = BackupDatabaseService(database);

    final settingsService = SettingsService(appStorageService);

    appLifecycleService.initialize();

    final avatarService = AppAvatarService();

    final storagePermissionService = StoragePermissionService();
    // final nativeAuthService = LocalAuthService(logger: loggerService);

    // final appLockManager = AppLockManager(
    //   authService: nativeAuthService,
    //   storageService: appStorageService,
    //   logger: loggerService,
    // );

    // await appLockManager.initialize();

    // appLifecycleService.addMethodToHandleLifecycleChanges(
    //   onAppResumed: () {
    //     loggerService.info('AppLock lifecycle callback: resumed');
    //     appLockManager.evaluateInactivity();
    //     appLockManager.recordInteraction();
    //   },
    //   onAppPaused: () {
    //     loggerService.info('AppLock lifecycle callback: paused');
    //     appLockManager.recordInteraction();
    //   },
    // );

    return AppDependencies(
      database: database,
      loggerService: loggerService,
      appStorageService: appStorageService,
      appLifecycleService: appLifecycleService,
      connectivityService: connectivityService,
      backendAuthService: backendAuthService,
      excelExportService: excelExportService,
      menuRepository: MenuRepository(menuDao),
      orderRepository: OrdersRepository(orderDao, orderItemDao),
      appSettingsRepository: AppSettingsRepository(appSettingsDao),
      subscriptionRepository: SubscriptionRepository(subscriptionDao),
      backupMetadataRepository: BackupMetadataRepository(backupMetadataDao),
      backupDatabaseService: backupDatabaseService,
      settingsService: settingsService,
      appAvatarService: avatarService,
      storagePermissionService: storagePermissionService,
      // appLockManager: appLockManager,
    );
  }
}
