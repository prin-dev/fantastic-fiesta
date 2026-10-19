import 'package:drift/drift.dart';

import 'connection/connection.dart';
import 'tables/menu_items_table.dart';
import 'tables/order_table.dart';
import 'tables/order_items_table.dart';
import 'tables/cart_draft_table.dart';
import 'tables/cart_draft_item.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    MenuItemTable,
    OrderTable,
    OrderItemsTable,
    CartDraftItemTable,
    CartDraftTable,
  ],
  daos: [],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      // onCreate: (Migrator m) async {
      //   await m.createAll();
      // },
      // onUpgrade: (Migrator m, int from, int to) async {
      //   if (from < 2) {
      //     await m.addColumn(menuTable, menuTable.icon);
      //   }
      //   if (from < 3) {
      //     // Re-add icon column in case it was missing from a v2 database
      //     // that was created without it
      //     await customStatement(
      //       'ALTER TABLE menu_table ADD COLUMN icon INTEGER NOT NULL DEFAULT 0;',
      //     );
      //   }
      // },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }
}
