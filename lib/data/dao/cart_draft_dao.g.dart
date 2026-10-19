// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_draft_dao.dart';

// ignore_for_file: type=lint
mixin _$CartDraftDaoMixin on DatabaseAccessor<AppDatabase> {
  $CartDraftTableTable get cartDraftTable => attachedDatabase.cartDraftTable;
  $CartDraftItemTableTable get cartDraftItemTable =>
      attachedDatabase.cartDraftItemTable;
  CartDraftDaoManager get managers => CartDraftDaoManager(this);
}

class CartDraftDaoManager {
  final _$CartDraftDaoMixin _db;
  CartDraftDaoManager(this._db);
  $$CartDraftTableTableTableManager get cartDraftTable =>
      $$CartDraftTableTableTableManager(
        _db.attachedDatabase,
        _db.cartDraftTable,
      );
  $$CartDraftItemTableTableTableManager get cartDraftItemTable =>
      $$CartDraftItemTableTableTableManager(
        _db.attachedDatabase,
        _db.cartDraftItemTable,
      );
}
