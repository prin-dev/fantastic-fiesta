import 'package:flutter/foundation.dart';
import 'package:movo/features/cart/cart_item.dart';

class Cart {
  final Map<String, CartItem> items;
  String customerAlias;
  String note;

  Cart({required this.items, required this.customerAlias, required this.note});

  void addItem(CartItem item) {
    // items.update(
    //   item.id,
    //   (existingItem) => existingItem.copyWith(
    //     quantity: existingItem.quantity + item.quantity,
    //     subtotal: existingItem.subtotal + item.subtotal,
    //   ),
    //   ifAbsent: () => item,
    // );
    if (kDebugMode) {
      print("added item");
      print(item);
      print("added item");
      print(
        'price: ${item.price}, quantity: ${item.quantity} = total: ${item.price * item.quantity}',
      );
    }
    items[item.id] = item;
  }

  void removeItem(CartItem item) {
    items.remove(item.id);
    if (kDebugMode) {
      print("removed item");
      print(
        'price: ${item.price}, quantity: ${item.quantity} = total: ${item.price * item.quantity}',
      );
    }
  }

  void increaseQuantity(String cartItemId) {
    if (items.containsKey(cartItemId)) {
      final item = items[cartItemId];
      if (item == null) return;
      final updatedItem = item.copyWith(quantity: item.quantity + 1);
      items[cartItemId] = updatedItem;
    }
  }

  void decreaseQuantity(String cartItemId) {
    if (items.containsKey(cartItemId)) {
      final item = items[cartItemId];
      if (item == null) return;
      if (item.quantity > 1) {
        final updatedItem = item.copyWith(quantity: item.quantity - 1);
        items[cartItemId] = updatedItem;
      } else {
        removeItem(item);
      }
    }
  }

  // void updateItemQuantity(String cartItemId, int newQuantity) {
  //   if (items.containsKey(cartItemId)) {
  //     final item = items[cartItemId];
  //     if (item == null) return;
  //     final updatedItem = item.copyWith(
  //       quantity: newQuantity,
  //     );
  //     total -= item.price; // Subtract the old price
  //     total += updatedItem.price; // Add the new price
  //     items[cartItemId] = updatedItem;
  //   }
  // }

  void clear() {
    items.clear();
    customerAlias = '';
    note = '';
  }
}
