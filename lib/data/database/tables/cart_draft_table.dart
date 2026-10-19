import 'package:drift/drift.dart';

class CartDraftTable extends Table {
  TextColumn get id => text()();

  TextColumn get customerAlias => text().nullable()();

  TextColumn get description => text().nullable()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
