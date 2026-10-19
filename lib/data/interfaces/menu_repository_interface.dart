import 'package:movo/data/database/app_database.dart';

abstract class IMenuRepository {
  Stream<List<MenuItemTableData>> watchAllMenu();
  Future<List<MenuItemTableData>> getAllMenu();
  Stream<List<MenuItemTableData>> watchActiveMenu();
  Future<List<MenuItemTableData>> getActiveMenu();
  Stream<List<MenuItemTableData>> watchInactiveMenu();
  Future<List<MenuItemTableData>> getInactiveMenu();
  Future<MenuItemTableData?> getMenuItemById(String id);
  Future<int> addMenuItem({
    required String icon,
    required String name,
    required List<int> prices,
    String? description,
    String? imageUrl,
  });
  Future<bool> updateMenuName({required String id, required String name});
  Future<bool> updateDisplayOrder({
    required String id,
    required int displayOrder,
  });
  Future<bool> updateMenuIcon({required String id, required String icon});
  Future<bool> updateMenuPrice({required String id, required List<int> prices});
  Future<void> deleteMenu(String id);
  Future<bool> activateMenuItem(String menuId);
  Future<bool> deactivateMenuItem(String menuId);
}
