import 'package:flutter/widgets.dart';
import 'package:movo/app/lifecycle/app_lifecycle_service.dart';
import 'package:movo/app/settings/settings_service.dart';
import 'package:movo/core/authentication/backend_auth_service.dart';
import 'package:movo/core/backup/backup_service.dart';
import 'package:movo/core/connectivity/connectivity_service.dart';
import 'package:movo/core/diagnostics/logger.dart';
import 'package:movo/core/export/excel_exporter.dart';
import 'package:movo/core/permissions/storage_permission_service.dart';
import 'package:movo/core/storage/storage_service.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/data/repositories/app_settings_repository.dart';
import 'package:movo/data/repositories/backup_metadata_repository.dart';
import 'package:movo/data/repositories/menu_repository.dart';
import 'package:movo/data/repositories/order_repository.dart';
import 'package:movo/data/repositories/subscription_repository.dart';
import 'package:movo/features/settings/avatar_service.dart';
import 'package:provider/provider.dart';

class AppDependencies {
  // Services
  final AppDatabase database;
  final LoggerService loggerService;
  final AppStorageService appStorageService;
  final AppLifecycleService appLifecycleService;
  final ConnectivityService connectivityService;
  final BackendAuthService backendAuthService;

  // Repositories
  final MenuRepository menuRepository;
  final OrdersRepository orderRepository;
  // final CartDraftRepository cartDraftRepository;
  final AppSettingsRepository appSettingsRepository;
  final ExcelExportService excelExportService;
  final SubscriptionRepository subscriptionRepository;
  final BackupMetadataRepository backupMetadataRepository;
  final BackupDatabaseService backupDatabaseService;
  final SettingsService settingsService;
  // final AppLockManager appLockManager;
  final AppAvatarService appAvatarService;

  final StoragePermissionService storagePermissionService;

  AppDependencies({
    required this.database,
    required this.loggerService,
    required this.appStorageService,
    required this.appLifecycleService,
    required this.connectivityService,
    required this.backendAuthService,
    required this.menuRepository,
    required this.orderRepository,
    // required this.cartDraftRepository,
    required this.appSettingsRepository,
    required this.excelExportService,
    required this.subscriptionRepository,
    required this.backupMetadataRepository,
    required this.backupDatabaseService,
    required this.settingsService,
    // required this.appLockManager,
    required this.appAvatarService,
    required this.storagePermissionService,
  });
}

extension AppDependenciesExtensions on BuildContext {
  AppDependencies get dependencies => read<AppDependencies>();
  MenuRepository get menuRepository => read<MenuRepository>();
  OrdersRepository get ordersRepository => read<OrdersRepository>();
  // CartDraftRepository get cartDraftRepository => read<CartDraftRepository>();
  AppSettingsRepository get appSettingsRepository =>
      read<AppSettingsRepository>();
  ExcelExportService get excelExportService => read<ExcelExportService>();
  SubscriptionRepository get subscriptionRepository =>
      read<SubscriptionRepository>();
  BackupDatabaseService get backupDatabaseService =>
      read<BackupDatabaseService>();
  SettingsService get settingsService => read<SettingsService>();
  AppAvatarService get appAvatarService => read<AppAvatarService>();
  StoragePermissionService get storagePermissionService =>
      read<StoragePermissionService>();
  LoggerService get loggerService => LoggerService();
}

// static Future<AppDependencies> create() async {
//   return AppDependencies(
//     database: database,
//     loggerService: loggerService,
//     appStorageService: appStorageService,
//     appLifecycleService: appLifecycleService,
//     connectivityService: connectivityService,
//     menuRepository: MenuRepository(menuDao),
//     orderRepository: OrdersRepository(orderDao),
//     appSettingsRepository: AppSettingsRepository(appSettingsDao),
//     subscriptionRepository: SubscriptionRepository(subscriptionDao),
//     backupMetadataRepository: BackupMetadataRepository(backupMetadataDao),
//   );
// }
