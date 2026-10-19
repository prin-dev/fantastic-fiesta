import 'package:drift/drift.dart';
import 'package:movo/data/database/app_database.dart';
import 'package:movo/data/database/tables/cart_draft_table.dart';
import 'package:movo/data/database/tables/cart_draft_item.dart';

part 'cart_draft_dao.g.dart';

@DriftAccessor(tables: [CartDraftTable, CartDraftItemTable])
class CartDraftDao extends DatabaseAccessor<AppDatabase>
    with _$CartDraftDaoMixin {
  CartDraftDao(super.db);

  Future<bool> addCartDraft({
    required String customerAlias,
    required String cartDraftId,
    required String cartDraftItemId,
    required String menuItemId,
    required String itemName,
    required String description,
    required int quantity,
    required int unitPricePaise,
  }) {
    return into(cartDraftTable)
        .insert(
          CartDraftTableCompanion.insert(
            updatedAt: DateTime.now(),
            id: cartDraftId,
            customerAlias: Value(customerAlias),
            description: Value(description),
          ),
        )
        .then((rowsAffected) {
          if (rowsAffected > 0) {
            return into(cartDraftItemTable)
                .insert(
                  CartDraftItemTableCompanion.insert(
                    itemName: itemName,
                    unitPricePaise: unitPricePaise,
                    id: cartDraftItemId,
                    cartDraftId: cartDraftId,
                    menuItemId: menuItemId,
                    quantity: quantity,
                  ),
                )
                .then((itemRowsAffected) => itemRowsAffected > 0);
          } else {
            return Future.value(false);
          }
        });
  }

  // Future<bool> updateCartDraft({
  //   required String cartDraftId,
  //   required int quantity,
  // }) {
  //   return (update(cartDraftTable)..where((tbl) => tbl.id.equals(cartDraftId)))
  //       .write(CartDraftTableCompanion(quantity: Value(quantity)))
  //       .then((rowsAffected) => rowsAffected > 0);
  // }

  Future<bool> removeCartDraftById({required String cartDraftId}) {
    return (delete(cartDraftTable)..where((tbl) => tbl.id.equals(cartDraftId)))
        .go()
        .then((rowsAffected) => rowsAffected > 0);
  }

  Stream<List<CartDraftTableData>> watchAllCartDrafts() {
    return select(cartDraftTable).watch();
  }
}
