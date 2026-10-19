import 'package:flutter/widgets.dart';
import 'package:fossui/fossui.dart';
import 'package:movo/app/bootstrap/app_bootstrap.dart';
import 'package:movo/app/dependencies/app_dependencies.dart';
import 'package:movo/app/settings/settings_service.dart';
import 'package:movo/core/backup/backup_service.dart';
import 'package:movo/core/export/excel_exporter.dart';
import 'package:movo/core/permissions/storage_permission_service.dart';
import 'package:movo/core/theme/movo_theme.dart';
import 'package:movo/data/repositories/app_settings_repository.dart';
import 'package:movo/data/repositories/menu_repository.dart';
import 'package:movo/data/repositories/order_repository.dart';
import 'package:movo/features/cart/cart_controller.dart';
import 'package:movo/features/settings/avatar_service.dart';
import 'package:movo/utils/navigator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const bootstrap = AppBootstrap();

  final dependencies = await bootstrap.initialize();

  runApp(MovoApp(dependencies: dependencies));
}

class MovoApp extends StatelessWidget {
  const MovoApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MenuRepository>.value(value: dependencies.menuRepository),
        Provider<OrdersRepository>.value(value: dependencies.orderRepository),
        Provider<ExcelExportService>.value(
          value: dependencies.excelExportService,
        ),
        Provider<BackupDatabaseService>.value(
          value: dependencies.backupDatabaseService,
        ),
        Provider<SettingsService>.value(value: dependencies.settingsService),

        // Provider.value(value: dependencies.cartDraftRepository),
        Provider<AppSettingsRepository>.value(
          value: dependencies.appSettingsRepository,
        ),
        Provider<AppAvatarService>.value(value: dependencies.appAvatarService),
        Provider<StoragePermissionService>.value(
          value: dependencies.storagePermissionService,
        ),
        // ChangeNotifierProvider<AppLockManager>(
        //   create: (_) => dependencies.appLockManager,
        // ),
        // Provider<SubscriptionRepository>.value(
        //   value: dependencies.subscriptionRepository,
        // ),
        // Provider.value(value: dependencies.subscriptionTimeEngine),
        // Provider.value(value: dependencies.appLockManager),
        ChangeNotifierProvider<CartController>(create: (_) => CartController()),
      ],
      child: OverlaySupport.global(
        child: FossTheme(
          data: MovoThemeData.lightTheme,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: FossToaster(
              child: WidgetsApp(
                color: const Color(0xFFFFFFFF),
                title: 'MOVO - Order, Payment, Done.',
                initialRoute: AppRoute.home.routeName,
                routes: AppNavigator.routes,
                builder: (context, child) => StoragePermissionGate(
                  child: child ?? const SizedBox.shrink(),
                ),
                pageRouteBuilder:
                    <T>(RouteSettings settings, WidgetBuilder builder) {
                  return PageRouteBuilder<T>(
                    settings: settings,
                    pageBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                    ) => builder(context),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
