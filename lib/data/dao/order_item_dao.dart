import 'package:drift/drift.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/data/database/tables/order_items_table.dart';

part 'order_item_dao.g.dart';

@DriftAccessor(tables: [OrderItemsTable])
class OrderItemDao extends DatabaseAccessor<AppDatabase>
    with _$OrderItemDaoMixin {
  OrderItemDao(super.db);

  Future<bool> addOrderItem({
    required String orderItemId,
    required String orderId,
    required String menuId,
    required String emoji,
    required int quantity,
    required String menuName,
    required int price,
  }) {
    return into(orderItemsTable)
        .insert(
          OrderItemsTableCompanion.insert(
            id: orderItemId,
            orderId: orderId,
            menuItemId: menuId,
            quantity: quantity,
            itemName: menuName,
            emoji: emoji,
            price: price,
            subtotal: (price * quantity).toInt(),
          ),
        )
        .then((rowsAffected) => rowsAffected > 0);
  }

  Future<bool> _updateOrderItem({
    required String orderId,
    required String menuId,
    required int quantity,
  }) {
    return (update(orderItemsTable)..where(
          (tbl) => tbl.orderId.equals(orderId) & tbl.menuItemId.equals(menuId),
        ))
        .write(
          OrderItemsTableCompanion(
            quantity: Value(quantity),
            subtotal: Value(
              (quantity * 100).toInt(),
            ), // Assuming price is 100 for simplicity
          ),
        )
        .then((rowsAffected) => rowsAffected > 0);
  }

  Future<bool> _removeOrderItemById({required String orderItemId}) {
    return (delete(orderItemsTable)..where((tbl) => tbl.id.equals(orderItemId)))
        .go()
        .then((rowsAffected) => rowsAffected > 0);
  }

  Stream<List<OrderItemsTableData>> watchOrderItemsByOrderId(String orderId) {
    return (select(
      orderItemsTable,
    )..where((tbl) => tbl.orderId.equals(orderId))).watch();
  }

  Future<List<OrderItemsTableData>> getOrderItemsByOrderId(String orderId) {
    return (select(
      orderItemsTable,
    )..where((tbl) => tbl.orderId.equals(orderId))).get();
  }
}
