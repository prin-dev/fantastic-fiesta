import 'package:drift/drift.dart';

class CartDraftItemTable extends Table {
  TextColumn get id => text()();

  TextColumn get cartDraftId => text()();

  TextColumn get menuItemId => text()();

  TextColumn get itemName => text()();

  IntColumn get quantity => integer()();

  IntColumn get unitPricePaise => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
