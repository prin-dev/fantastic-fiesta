import 'package:drift/drift.dart';

enum OrderStatus { pending, paid, cancelled }

enum PaymentMethod { cash, upi, card }

class OrderTable extends Table {
  TextColumn get id => text()();

  TextColumn get customerAlias => text().nullable()();

  TextColumn get customerPhone => text().nullable()();

  TextColumn get status => text().withDefault(const Constant('pending'))();

  IntColumn get total => integer().withDefault(const Constant(0))();

  IntColumn get itemCount => integer()();

  TextColumn get paymentMethod => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get paidAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
