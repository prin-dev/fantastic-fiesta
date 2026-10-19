import 'package:flutter/foundation.dart';
import 'package:movo/data/repositories/order_repository.dart';
import 'package:movo/features/cart/cart.dart';
import 'package:movo/features/cart/cart_item.dart';

class CartController extends ChangeNotifier {
  // double _total = 0;

  // String _customerName = '';

  // List<CartItem> _items = [];

  // bool _isUpdating = false;

  // String _updatingOrderId = '';

  final Cart _cart = Cart(items: {}, customerAlias: '', note: '');

  // Getters
  Cart get cart => _cart;

  // DateTime? _lastUpdated;

  // DateTime? get lastUpdated => _lastUpdated;

  bool get isCartEmpty => _cart.items.isEmpty;

  int get itemCount =>
      _cart.items.entries.fold(0, (sum, entry) => sum + entry.value.quantity);

  int get total => _cart.items.entries.fold(
    0,
    (sum, entry) => sum + (entry.value.price * entry.value.quantity),
  );

  // bool get isUpdating => _isUpdating;
  // String get updatingOrderId => _updatingOrderId;

  void editCustomerName(String name) {
    _cart.customerAlias = name;
    notifyListeners();
  }

  void addItemToCart(CartItem item) {
    _cart.addItem(item);
    if (kDebugMode) {
      print("added item");
    }
    if (kDebugMode) {
      print(
        'price: ${item.price}, quantity: ${item.quantity} = total: ${item.price * item.quantity}',
      );
    }
    notifyListeners();
  }

  void removeItemFromCart(CartItem item) {
    _cart.removeItem(item);
    notifyListeners();
  }

  void increaseItemQuantity(String menuItemId) {
    _cart.increaseQuantity(menuItemId);
    notifyListeners();
  }

  void decreaseItemQuantity(String menuItemId) {
    _cart.decreaseQuantity(menuItemId);
    notifyListeners();
  }

  // void updateItemQuantity(String menuItemId, int newQuantity) {
  //   _cart.updateItemQuantity(menuItemId, newQuantity);
  //   notifyListeners();
  // }

  int? getCartItemCountById(String cartItemId) {
    try {
      final item = _cart.items[cartItemId];
      return item?.quantity;
    } catch (e) {
      return null; // Return null if the item is not found
    }
  }

  int? getCartItemCountByMenuId(String menuId) {
    try {
      final count = _cart.items.entries
          .where((entry) => entry.value.menuItemId == menuId)
          .fold(0, (sum, entry) => sum + entry.value.quantity);
      return count;
    } catch (e) {
      return null; // Return null if the item is not found
    }
  }

  void setCustomerAlias(String alias) {
    _cart.customerAlias = alias;
    notifyListeners();
  }

  void setNote(String note) {
    _cart.note = note;
    notifyListeners();
  }

  void placeOrder(OrdersRepository orderRepository) {
    if (_cart.items.isEmpty) {
      if (kDebugMode) {
        print("Cart is empty. Cannot place order.");
      }
      throw FlutterError("Cart is empty. Cannot place order.");
    }
    if (_cart.customerAlias.isEmpty) {
      if (kDebugMode) {
        print("Customer name is empty. Cannot place order.");
      }
      throw FlutterError("Customer name is empty. Cannot place order.");
    }
    orderRepository.addOrder(
      itemCount: itemCount,
      cartItems: _cart.items.values.toList(),
      customerName: _cart.customerAlias,
      totalAmount: total,
    );
    if (kDebugMode) {
      print("Order placed with total: $total");
    }
    _cart.clear(); // Clear the cart after placing the order
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // void setCartFromOrder(
  //   OrderItemsTableData order,
  //   List<OrderItemsTableData> orderItems,
  // ) {
  //   _items.clear();
  //   _isUpdating = true;
  //   _customerName = order.customerAlias ?? '';
  //   _total = order.total;
  //   _updatingOrderId = order.id;
  //   for (var item in orderItems) {
  //     final cartItem = CartItem(
  //       id: item.id,
  //       menuId: item.menuId,
  //       menuName: item.menuName,
  //       price: item.price,
  //       quantity: item.quantity,
  //     );
  //     _items.add(cartItem);
  //   }
  //   notifyListeners();
  // }

  // void confirmUpdate() {
  //   clear();
  //   _isUpdating = false;
  //   notifyListeners();
  // }

  // void updateItem(CartItem item) {
  //   _items.clear();
  //   _total = 0;
  //   final cartItem = CartItem(
  //     id: item.id,
  //     menuId: item.menuId,
  //     menuName: item.menuName,
  //     price: item.price,
  //     quantity: item.quantity,
  //   );
  //   _items.add(cartItem);
  //   _total += (item.price * item.quantity);
  //   notifyListeners();
  // }

  // void removeItem(String itemId) {
  //   final item = _items.firstWhere((i) => i.id == itemId);
  //   print("removing item: ${item.menuName} id: ${item.menuId}");
  //   _total -= ((item.price) * (item.quantity));
  //   _items.removeWhere((i) => i.id == itemId);
  //   notifyListeners();
  // }

  // void clear() {
  //   _items.clear();
  //   _customerName = '';
  //   _total = 0;
  //   _isUpdating = false;
  //   _updatingOrderId = '';
  //   notifyListeners();
  // }
}
