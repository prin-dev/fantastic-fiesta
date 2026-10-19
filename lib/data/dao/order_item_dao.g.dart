// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_dao.dart';

// ignore_for_file: type=lint
mixin _$OrderItemDaoMixin on DatabaseAccessor<AppDatabase> {
  $OrderTableTable get orderTable => attachedDatabase.orderTable;
  $OrderItemsTableTable get orderItemsTable => attachedDatabase.orderItemsTable;
  OrderItemDaoManager get managers => OrderItemDaoManager(this);
}

class OrderItemDaoManager {
  final _$OrderItemDaoMixin _db;
  OrderItemDaoManager(this._db);
  $$OrderTableTableTableManager get orderTable =>
      $$OrderTableTableTableManager(_db.attachedDatabase, _db.orderTable);
  $$OrderItemsTableTableTableManager get orderItemsTable =>
      $$OrderItemsTableTableTableManager(
        _db.attachedDatabase,
        _db.orderItemsTable,
      );
}
