import 'package:flutter/widgets.dart';
import 'package:movo/features/home/home_screen.dart';
import 'package:movo/features/menu/menu_screen.dart';
import 'package:movo/features/menu/widgets/add_menu_sheet.dart';
import 'package:movo/features/menu/widgets/edit_menu_sheet.dart';
import 'package:movo/features/orders/orders_screen.dart';
import 'package:movo/features/security/app_lock_screen.dart';
import 'package:movo/features/settings/settings_screen.dart';

enum AppRoute {
  home(routeName: '/'),
  menu(routeName: '/menu'),
  order(routeName: '/order'),
  settings(routeName: '/settings'),
  locked(routeName: '/locked'),
  addMenuItem(routeName: '/add_menu_item'),
  editMenuItem(routeName: '/edit_menu_item');

  final String routeName;

  const AppRoute({required this.routeName});
}

class AppNavigator {
  static final Map<String, WidgetBuilder> routes = {
    AppRoute.home.routeName: (_) => const Homepage(),
    AppRoute.menu.routeName: (_) => const MenuScreen(),
    AppRoute.order.routeName: (_) => const OrderScreen(),
    AppRoute.settings.routeName: (_) => const SettingsScreen(),
    AppRoute.locked.routeName: (_) => const AppLockScreen(),
    AppRoute.addMenuItem.routeName: (_) => const AddMenuScreen(),
    AppRoute.editMenuItem.routeName: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as EditMenuScreen;

      return EditMenuScreen(
        menuId: args.menuId,
        initialItemName: args.initialItemName,
        initialPrices: args.initialPrices,
        initialIcon: args.initialIcon,
      );
    },
  };
}

extension AppRouterExtension on BuildContext {
  void navigateTo<T>(AppRoute route, {T? arguments}) {
    Navigator.of(this).pushNamed(route.routeName, arguments: arguments);
  }

  void navigateToHome() => navigateTo(AppRoute.home);
  void navigateToMenu() => navigateTo(AppRoute.menu);
  void navigateToOrder() => navigateTo(AppRoute.order);
  void navigateToSettings() => navigateTo(AppRoute.settings);
  void navigateToLocked() => navigateTo(AppRoute.locked);
  void navigateToAddMenuItemScreen() => navigateTo(AppRoute.addMenuItem);
  void navigateToEditMenuItemScreen({
    required String menuId,
    required String initialItemName,
    required List<int> initialPrices,
    required String initialIcon,
  }) => navigateTo<EditMenuScreen>(
    AppRoute.editMenuItem,
    arguments: EditMenuScreen(
      menuId: menuId,
      initialItemName: initialItemName,
      initialPrices: initialPrices,
      initialIcon: initialIcon,
    ),
  );

  void goBack() => Navigator.of(this).pop();
}
