// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_dao.dart';

// ignore_for_file: type=lint
mixin _$MenuDaoMixin on DatabaseAccessor<AppDatabase> {
  $MenuItemTableTable get menuItemTable => attachedDatabase.menuItemTable;
  MenuDaoManager get managers => MenuDaoManager(this);
}

class MenuDaoManager {
  final _$MenuDaoMixin _db;
  MenuDaoManager(this._db);
  $$MenuItemTableTableTableManager get menuItemTable =>
      $$MenuItemTableTableTableManager(_db.attachedDatabase, _db.menuItemTable);
}
