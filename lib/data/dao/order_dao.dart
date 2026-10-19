import 'package:drift/drift.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/data/database/tables/order_table.dart';

part 'order_dao.g.dart';

@DriftAccessor(tables: [OrderTable])
class OrderDao extends DatabaseAccessor<AppDatabase> with _$OrderDaoMixin {
  OrderDao(super.db);

  Future<({String orderId, bool success})> addOrder({
    required String orderId,
    required int totalAmount,
    required int itemCount,
    required DateTime orderDate,
    required OrderStatus orderStatus,
    required String customerAlias,
    String? customerPhone,
  }) async {
    final inserted = await into(orderTable)
        .insert(
          OrderTableCompanion.insert(
            id: orderId,
            itemCount: itemCount,
            total: Value(totalAmount),
            createdAt: Value(orderDate),
            status: Value(orderStatus.toString().split('.').last),
            customerAlias: Value(customerAlias),
            customerPhone: Value(customerPhone),
          ),
        )
        .then((rowsAffected) => rowsAffected > 0);

    return (orderId: orderId, success: inserted);
  }

  Future<bool> updateOrder(
    String orderId, {
    required int totalAmount,
    required int itemCount,
    String? customerAlias,
    String? customerPhone,
    OrderStatus orderStatus = OrderStatus.pending,
  }) {
    return (update(orderTable)..where((tbl) => tbl.id.equals(orderId)))
        .write(
          OrderTableCompanion(
            total: Value(totalAmount),
            customerAlias: Value(customerAlias),
            customerPhone: Value(customerPhone),
            status: Value(orderStatus.toString().split('.').last),
          ),
        )
        .then((rowsAffected) => rowsAffected > 0);
  }

  Future<bool> markPaid(String orderId, PaymentMethod paymentMethod) {
    return (update(orderTable)..where((tbl) => tbl.id.equals(orderId)))
        .write(
          OrderTableCompanion(
            status: Value(OrderStatus.paid.toString().split('.').last),
            paymentMethod: Value(paymentMethod.toString().split('.').last),
            paidAt: Value(DateTime.now()),
          ),
        )
        .then((rowsAffected) => rowsAffected > 0);
  }

  Future<bool> markCancelled(String orderId) {
    return (update(orderTable)..where((tbl) => tbl.id.equals(orderId)))
        .write(
          OrderTableCompanion(
            status: Value(OrderStatus.cancelled.toString().split('.').last),
          ),
        )
        .then((rowsAffected) => rowsAffected > 0);
  }

  Future<bool> markPending(String orderId) {
    return (update(orderTable)..where((tbl) => tbl.id.equals(orderId)))
        .write(
          OrderTableCompanion(
            status: Value(OrderStatus.pending.toString().split('.').last),
          ),
        )
        .then((rowsAffected) => rowsAffected > 0);
  }

  Future<bool> deleteOrder(String orderId) {
    return (delete(orderTable)..where((tbl) => tbl.id.equals(orderId)))
        .go()
        .then((rowsAffected) => rowsAffected > 0);
  }

  Future<OrderTableData?> getOrderById(String orderId) {
    return (select(
      orderTable,
    )..where((tbl) => tbl.id.equals(orderId))).getSingleOrNull();
  }

  Stream<List<OrderTableData>> watchCompletedOrders() {
    return (select(orderTable)..where(
          (tbl) =>
              tbl.status.equals(OrderStatus.paid.toString().split('.').last),
        ))
        .watch();
  }

  Stream<List<OrderTableData>> watchPendingOrders() {
    return (select(orderTable)
          ..where(
            (tbl) => tbl.status.equals(
              OrderStatus.pending.toString().split('.').last,
            ),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .watch();
  }

  Stream<List<OrderTableData>> watchCancelledOrders() {
    return (select(orderTable)..where(
          (tbl) => tbl.status.equals(
            OrderStatus.cancelled.toString().split('.').last,
          ),
        ))
        .watch();
  }

  Future<List<OrderTableData>> getPendingOrders() {
    return (select(orderTable)
          ..where(
            (tbl) => tbl.status.equals(
              OrderStatus.pending.toString().split('.').last,
            ),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  Future<List<OrderTableData>> getAllOrders() {
    return (select(
      orderTable,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])).get();
  }

  Future<List<OrderTableData>> getCompletedOrders() {
    return (select(orderTable)
          ..where(
            (tbl) =>
                tbl.status.equals(OrderStatus.paid.toString().split('.').last),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  Future<List<OrderTableData>> getPendingOrdersByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _getOrdersByDateRange(
      startDate: startDate,
      endDate: endDate,
      status: OrderStatus.pending.toString().split('.').last,
    );
  }

  Future<List<OrderTableData>> getCompletedOrdersByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _getOrdersByDateRange(
      startDate: startDate,
      endDate: endDate,
      status: OrderStatus.paid.toString().split('.').last,
    );
  }

  Future<List<OrderTableData>> getAllOrdersByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _getOrdersByDateRange(startDate: startDate, endDate: endDate);
  }

  Future<List<OrderTableData>> _getOrdersByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? status,
  }) {
    final query = select(orderTable)
      ..where(
        (tbl) {
          final dateFilter =
              tbl.createdAt.isBiggerOrEqualValue(startDate) &
              tbl.createdAt.isSmallerThanValue(endDate);
          return status == null
              ? dateFilter
              : dateFilter & tbl.status.equals(status);
        },
      )
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
    return query.get();
  }

  Stream<List<OrderTableData>> watchAllOrders() {
    return (select(
      orderTable,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])).watch();
  }

  Stream<OrderTableData?> watchOrderById(String orderId) {
    return (select(
      orderTable,
    )..where((tbl) => tbl.id.equals(orderId))).watchSingleOrNull();
  }
}
