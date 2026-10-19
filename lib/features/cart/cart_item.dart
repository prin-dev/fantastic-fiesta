class CartItem {
  final String id;
  final String menuItemId;
  final String emoji;
  final String itemName;
  final int price;
  final int quantity;

  CartItem({
    required this.id,
    required this.menuItemId,
    required this.emoji,
    required this.itemName,
    required this.price,
    required this.quantity,
  });

  @override
  String toString() {
    return 'CartItem{id: $id, menuItemId: $menuItemId, itemName: $itemName, price: $price, quantity: $quantity}';
  }

  // copy with method to create a new instance with updated values
  CartItem copyWith({
    String? id,
    String? menuItemId,
    String? emoji,
    String? itemName,
    int? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      emoji: emoji ?? this.emoji,
      itemName: itemName ?? this.itemName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
