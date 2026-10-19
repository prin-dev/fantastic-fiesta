import 'package:flutter/foundation.dart';
import 'package:movo/data/dao/order_dao.dart';
import 'package:movo/data/dao/order_item_dao.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/data/database/tables/order_table.dart';
import 'package:movo/features/cart/cart_item.dart';
import 'package:uuid/uuid.dart';

class OrdersRepository {
  final OrderDao _orderDao;
  final OrderItemDao _orderItemsDao;

  OrdersRepository(this._orderDao, this._orderItemsDao);

  // Future<List<OrderTableData>> getDemoOrders() async {
  //   final List<OrderTableData> orders = [
  //     OrderTableData(
  //       createdAt: DateTime(2024, 6, 1, 10, 30),
  //       customerAlias: 'John Doe',
  //       total: 100,
  //       id: 'id_1',
  //       status: OrderStatus.pending.toString(),
  //     ),
  //     OrderTableData(
  //       createdAt: DateTime(2024, 6, 2, 14, 45),
  //       customerAlias: 'Jane Smith',
  //       total: 150,
  //       id: 'id_2',
  //       status: OrderStatus.pending.toString(),
  //     ),
  //     OrderTableData(
  //       createdAt: DateTime(2024, 6, 3, 9, 15),
  //       customerAlias: 'Alice Johnson',
  //       total: 200,
  //       id: 'id_3',
  //       status: OrderStatus.pending.toString(),
  //     ),
  //     OrderTableData(
  //       createdAt: DateTime(2024, 6, 4, 11, 30),
  //       customerAlias: 'Bob Williams',
  //       total: 250,
  //       id: 'id_4',
  //       status: OrderStatus.pending.toString(),
  //     ),
  //   ];

  //   return orders;
  // }

  Future<({String orderId, bool success})> addOrder({
    required String customerName,
    required int totalAmount,
    required int itemCount,
    required List<CartItem> cartItems,
    String? customerPhone,
  }) async {
    final orderId = const Uuid().v7();
    return _orderDao
        .addOrder(
          orderId: orderId,
          itemCount: itemCount,
          customerAlias: customerName,
          customerPhone: customerPhone,
          totalAmount: totalAmount,
          orderDate: DateTime.now(),
          orderStatus: OrderStatus.pending,
        )
        .then((result) async {
          if (result.success) {
            for (final item in cartItems) {
              if (kDebugMode) {
                print(
                  'Adding order item: ${item.itemName} with quantity: ${item.quantity}',
                );
              }
              await _orderItemsDao.addOrderItem(
                orderItemId: const Uuid().v7(),
                orderId: orderId,
                emoji: item.emoji,
                menuId: item.menuItemId,
                quantity: item.quantity,
                menuName: item.itemName,
                price: item.price,
              );
            }
          }
          return result;
        });
  }

  Future<bool> updateOrder(
    String orderId, {
    required int totalAmount,
    required int itemCount,
    String? customerAlias,
    String? customerPhone,
    OrderStatus orderStatus = OrderStatus.pending,
  }) async {
    return await _orderDao.updateOrder(
      orderId,
      totalAmount: totalAmount,
      customerAlias: customerAlias,
      customerPhone: customerPhone,
      itemCount: itemCount,
      orderStatus: orderStatus,
    );
  }

  Future<bool> markOrderPaid({
    required String orderId,
    required PaymentMethod paymentMethod,
  }) async {
    return await _orderDao.markPaid(orderId, paymentMethod);
  }

  Future<bool> markOrderCancelled(String orderId) async {
    return await _orderDao.markCancelled(orderId);
  }

  Future<bool> markOrderPending(String orderId) async {
    return await _orderDao.markPending(orderId);
  }

  Future<bool> deleteOrder(String orderId) async {
    return await _orderDao.deleteOrder(orderId);
  }

  Future<OrderTableData?> getOrderById(String orderId) async {
    return await _orderDao.getOrderById(orderId);
  }

  Stream<List<OrderTableData>> watchAllOrders() {
    return _orderDao.watchAllOrders();
  }

  Future<List<OrderTableData>> getPendingOrders() async {
    return await _orderDao.getPendingOrders();
  }

  Future<List<OrderTableData>> getAllOrders() async {
    return await _orderDao.getAllOrders();
  }

  Future<List<OrderTableData>> getCompletedOrders() async {
    return await _orderDao.getCompletedOrders();
  }

  Future<List<OrderTableData>> getPendingOrdersByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _orderDao.getPendingOrdersByDateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<List<OrderTableData>> getCompletedOrdersByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _orderDao.getCompletedOrdersByDateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<List<OrderTableData>> getAllOrdersByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _orderDao.getAllOrdersByDateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }

  Stream<List<OrderTableData>> watchCompletedOrders() {
    return _orderDao.watchCompletedOrders();
  }

  Stream<List<OrderTableData>> watchPendingOrders() {
    return _orderDao.watchPendingOrders();
  }

  Stream<List<OrderTableData>> watchCancelledOrders() {
    return _orderDao.watchCancelledOrders();
  }

  Stream<OrderTableData?> watchOrderById(String orderId) {
    return _orderDao.watchOrderById(orderId);
  }

  Future<List<OrderItemsTableData>> getOrderItemsByOrderId(String orderId) {
    return _orderItemsDao.getOrderItemsByOrderId(orderId);
  }

  Future<({OrderTableData order, List<OrderItemsTableData> orderItems})>
  getOrderWithItems(String orderId) async {
    final order = await _orderDao.getOrderById(orderId);
    if (order == null) {
      throw Exception('Order not found');
    }
    final orderItems = await _orderItemsDao.getOrderItemsByOrderId(orderId);
    return (order: order, orderItems: orderItems);
  }
}
