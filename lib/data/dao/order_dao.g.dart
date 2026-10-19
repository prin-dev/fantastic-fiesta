// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dao.dart';

// ignore_for_file: type=lint
mixin _$OrderDaoMixin on DatabaseAccessor<AppDatabase> {
  $OrderTableTable get orderTable => attachedDatabase.orderTable;
  OrderDaoManager get managers => OrderDaoManager(this);
}

class OrderDaoManager {
  final _$OrderDaoMixin _db;
  OrderDaoManager(this._db);
  $$OrderTableTableTableManager get orderTable =>
      $$OrderTableTableTableManager(_db.attachedDatabase, _db.orderTable);
}
