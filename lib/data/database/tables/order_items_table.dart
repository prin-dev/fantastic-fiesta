import 'package:drift/drift.dart';

import 'order_table.dart';

class OrderItemsTable extends Table {
  TextColumn get id => text()();

  TextColumn get orderId =>
      text().references(OrderTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get menuItemId => text()();

  TextColumn get itemName => text()();

  TextColumn get emoji => text()();

  IntColumn get price => integer()();

  IntColumn get quantity => integer()();

  IntColumn get subtotal => integer()();
}
