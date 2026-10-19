import 'dart:convert';

import 'package:drift/drift.dart';

class IntListConverter extends TypeConverter<List<int>, String> {
  const IntListConverter();

  @override
  List<int> fromSql(String fromDb) {
    final List<dynamic> decoded = json.decode(fromDb);
    return decoded.map((e) => (e as num).toInt()).toList();
  }

  @override
  String toSql(List<int> value) {
    return json.encode(value);
  }
}

class MenuItemTable extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  TextColumn get prices => text().map(const IntListConverter())();

  TextColumn get icon => text()();

  TextColumn get description => text().nullable()();

  TextColumn get imageUrl => text().nullable()();

  IntColumn get displayOrder => integer().autoIncrement()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
