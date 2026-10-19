import 'package:drift/drift.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/data/database/tables/menu_items_table.dart';

import 'package:uuid/uuid.dart';

part 'menu_item_dao.g.dart';

@DriftAccessor(tables: [MenuItemTable])
class MenuDao extends DatabaseAccessor<AppDatabase> with _$MenuDaoMixin {
  MenuDao(super.db);

  // Stream<List<MenuItemTableData>> watchActiveMenu() {
  //   return (select(menuItemTable)
  //         ..where((tbl) => tbl.isActive.equals(true))
  //         ..orderBy([(tbl) => OrderingTerm.asc(tbl.displayOrder)]))
  //       .watch();
  // }

  Future<List<MenuItemTableData>> getAllMenu() {
    return (select(
      menuItemTable,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.displayOrder)])).get();
  }

  Stream<List<MenuItemTableData>> watchAllMenu() {
    return (select(
      menuItemTable,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.displayOrder)])).watch();
  }

  Stream<List<MenuItemTableData>> watchMenuByStatus(bool isActive) {
    return (select(menuItemTable)
          ..where((tbl) => tbl.isActive.equals(isActive))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.displayOrder)]))
        .watch();
  }

  Future<List<MenuItemTableData>> getMenuByStatus(bool isActive) {
    return (select(menuItemTable)
          ..where((tbl) => tbl.isActive.equals(isActive))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.displayOrder)]))
        .get();
  }

  Future<MenuItemTableData?> getMenuItemById(String id) {
    return (select(
      menuItemTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> addMenuItem({
    required String icon,
    required String name,
    required List<int> prices,
    String? id,
    String? description,
    String? imageUrl,
    int? displayOrder,
  }) {
    return into(menuItemTable).insert(
      MenuItemTableCompanion.insert(
        id: id ?? const Uuid().v7(),
        description: Value(description),
        imageUrl: Value(imageUrl),
        icon: icon,
        name: name,
        prices: prices,
      ),
    );
  }

  Future<bool> updateMenuName({required String id, required String name}) {
    return (update(menuItemTable)..where((tbl) => tbl.id.equals(id)))
        .write(MenuItemTableCompanion(name: Value(name)))
        .then((rowsAffected) => rowsAffected > 0);
  }

  Future<bool> updateMenuIcon({required String id, required String icon}) {
    return (update(menuItemTable)..where((tbl) => tbl.id.equals(id)))
        .write(MenuItemTableCompanion(icon: Value(icon)))
        .then((rowsAffected) => rowsAffected > 0);
  }

  Future<bool> updateDisplayOrder({
    required String id,
    required int displayOrder,
  }) {
    return (update(menuItemTable)..where((tbl) => tbl.id.equals(id)))
        .write(MenuItemTableCompanion(displayOrder: Value(displayOrder)))
        .then((rowsAffected) => rowsAffected > 0);
  }

  Future<bool> updateMenuStatus({required String id, required bool isActive}) {
    return (update(menuItemTable)..where((tbl) => tbl.id.equals(id)))
        .write(MenuItemTableCompanion(isActive: Value(isActive)))
        .then((rowsAffected) => rowsAffected > 0);
  }

  Future<bool> updateMenuPrice({
    required String id,
    required List<int> prices,
  }) {
    return (update(menuItemTable)..where((tbl) => tbl.id.equals(id)))
        .write(MenuItemTableCompanion(prices: Value(prices)))
        .then((rowsAffected) => rowsAffected > 0);
  }

  // Future<bool> toggleMenu({required String id, required bool active}) {
  //   return (update(menuItemTable)..where((tbl) => tbl.id.equals(id)))
  //       .write(MenuItemTableCompanion(isActive: Value(active)))
  //       .then((rowsAffected) => rowsAffected > 0);
  // }

  Future<int> deleteMenu(String id) {
    return (delete(menuItemTable)..where((tbl) => tbl.id.equals(id))).go();
  }
}
