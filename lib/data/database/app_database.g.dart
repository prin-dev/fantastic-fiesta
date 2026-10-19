// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MenuItemTableTable extends MenuItemTable
    with TableInfo<$MenuItemTableTable, MenuItemTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenuItemTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String> prices =
      GeneratedColumn<String>(
        'prices',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<int>>($MenuItemTableTable.$converterprices);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isActive,
    prices,
    icon,
    description,
    imageUrl,
    displayOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menu_item_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MenuItemTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {displayOrder};
  @override
  MenuItemTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuItemTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      prices: $MenuItemTableTable.$converterprices.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}prices'],
        )!,
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MenuItemTableTable createAlias(String alias) {
    return $MenuItemTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<int>, String> $converterprices =
      const IntListConverter();
}

class MenuItemTableData extends DataClass
    implements Insertable<MenuItemTableData> {
  final String id;
  final String name;
  final bool isActive;
  final List<int> prices;
  final String icon;
  final String? description;
  final String? imageUrl;
  final int displayOrder;
  final DateTime createdAt;
  const MenuItemTableData({
    required this.id,
    required this.name,
    required this.isActive,
    required this.prices,
    required this.icon,
    this.description,
    this.imageUrl,
    required this.displayOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    {
      map['prices'] = Variable<String>(
        $MenuItemTableTable.$converterprices.toSql(prices),
      );
    }
    map['icon'] = Variable<String>(icon);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['display_order'] = Variable<int>(displayOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MenuItemTableCompanion toCompanion(bool nullToAbsent) {
    return MenuItemTableCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
      prices: Value(prices),
      icon: Value(icon),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      displayOrder: Value(displayOrder),
      createdAt: Value(createdAt),
    );
  }

  factory MenuItemTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuItemTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      prices: serializer.fromJson<List<int>>(json['prices']),
      icon: serializer.fromJson<String>(json['icon']),
      description: serializer.fromJson<String?>(json['description']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
      'prices': serializer.toJson<List<int>>(prices),
      'icon': serializer.toJson<String>(icon),
      'description': serializer.toJson<String?>(description),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MenuItemTableData copyWith({
    String? id,
    String? name,
    bool? isActive,
    List<int>? prices,
    String? icon,
    Value<String?> description = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    int? displayOrder,
    DateTime? createdAt,
  }) => MenuItemTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    isActive: isActive ?? this.isActive,
    prices: prices ?? this.prices,
    icon: icon ?? this.icon,
    description: description.present ? description.value : this.description,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    displayOrder: displayOrder ?? this.displayOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  MenuItemTableData copyWithCompanion(MenuItemTableCompanion data) {
    return MenuItemTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      prices: data.prices.present ? data.prices.value : this.prices,
      icon: data.icon.present ? data.icon.value : this.icon,
      description: data.description.present
          ? data.description.value
          : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('prices: $prices, ')
          ..write('icon: $icon, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    isActive,
    prices,
    icon,
    description,
    imageUrl,
    displayOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuItemTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.prices == this.prices &&
          other.icon == this.icon &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt);
}

class MenuItemTableCompanion extends UpdateCompanion<MenuItemTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<List<int>> prices;
  final Value<String> icon;
  final Value<String?> description;
  final Value<String?> imageUrl;
  final Value<int> displayOrder;
  final Value<DateTime> createdAt;
  const MenuItemTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.prices = const Value.absent(),
    this.icon = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MenuItemTableCompanion.insert({
    required String id,
    required String name,
    this.isActive = const Value.absent(),
    required List<int> prices,
    required String icon,
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       prices = Value(prices),
       icon = Value(icon);
  static Insertable<MenuItemTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? isActive,
    Expression<String>? prices,
    Expression<String>? icon,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (prices != null) 'prices': prices,
      if (icon != null) 'icon': icon,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MenuItemTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<bool>? isActive,
    Value<List<int>>? prices,
    Value<String>? icon,
    Value<String?>? description,
    Value<String?>? imageUrl,
    Value<int>? displayOrder,
    Value<DateTime>? createdAt,
  }) {
    return MenuItemTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      prices: prices ?? this.prices,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (prices.present) {
      map['prices'] = Variable<String>(
        $MenuItemTableTable.$converterprices.toSql(prices.value),
      );
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('prices: $prices, ')
          ..write('icon: $icon, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $OrderTableTable extends OrderTable
    with TableInfo<$OrderTableTable, OrderTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerAliasMeta = const VerificationMeta(
    'customerAlias',
  );
  @override
  late final GeneratedColumn<String> customerAlias = GeneratedColumn<String>(
    'customer_alias',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerPhoneMeta = const VerificationMeta(
    'customerPhone',
  );
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
    'customer_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _itemCountMeta = const VerificationMeta(
    'itemCount',
  );
  @override
  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
    'item_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerAlias,
    customerPhone,
    status,
    total,
    itemCount,
    paymentMethod,
    createdAt,
    paidAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_alias')) {
      context.handle(
        _customerAliasMeta,
        customerAlias.isAcceptableOrUnknown(
          data['customer_alias']!,
          _customerAliasMeta,
        ),
      );
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
        _customerPhoneMeta,
        customerPhone.isAcceptableOrUnknown(
          data['customer_phone']!,
          _customerPhoneMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('item_count')) {
      context.handle(
        _itemCountMeta,
        itemCount.isAcceptableOrUnknown(data['item_count']!, _itemCountMeta),
      );
    } else if (isInserting) {
      context.missing(_itemCountMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerAlias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_alias'],
      ),
      customerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_phone'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      itemCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_count'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      ),
    );
  }

  @override
  $OrderTableTable createAlias(String alias) {
    return $OrderTableTable(attachedDatabase, alias);
  }
}

class OrderTableData extends DataClass implements Insertable<OrderTableData> {
  final String id;
  final String? customerAlias;
  final String? customerPhone;
  final String status;
  final int total;
  final int itemCount;
  final String? paymentMethod;
  final DateTime createdAt;
  final DateTime? paidAt;
  const OrderTableData({
    required this.id,
    this.customerAlias,
    this.customerPhone,
    required this.status,
    required this.total,
    required this.itemCount,
    this.paymentMethod,
    required this.createdAt,
    this.paidAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || customerAlias != null) {
      map['customer_alias'] = Variable<String>(customerAlias);
    }
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    map['status'] = Variable<String>(status);
    map['total'] = Variable<int>(total);
    map['item_count'] = Variable<int>(itemCount);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    return map;
  }

  OrderTableCompanion toCompanion(bool nullToAbsent) {
    return OrderTableCompanion(
      id: Value(id),
      customerAlias: customerAlias == null && nullToAbsent
          ? const Value.absent()
          : Value(customerAlias),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      status: Value(status),
      total: Value(total),
      itemCount: Value(itemCount),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      createdAt: Value(createdAt),
      paidAt: paidAt == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAt),
    );
  }

  factory OrderTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderTableData(
      id: serializer.fromJson<String>(json['id']),
      customerAlias: serializer.fromJson<String?>(json['customerAlias']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      status: serializer.fromJson<String>(json['status']),
      total: serializer.fromJson<int>(json['total']),
      itemCount: serializer.fromJson<int>(json['itemCount']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerAlias': serializer.toJson<String?>(customerAlias),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'status': serializer.toJson<String>(status),
      'total': serializer.toJson<int>(total),
      'itemCount': serializer.toJson<int>(itemCount),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
    };
  }

  OrderTableData copyWith({
    String? id,
    Value<String?> customerAlias = const Value.absent(),
    Value<String?> customerPhone = const Value.absent(),
    String? status,
    int? total,
    int? itemCount,
    Value<String?> paymentMethod = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> paidAt = const Value.absent(),
  }) => OrderTableData(
    id: id ?? this.id,
    customerAlias: customerAlias.present
        ? customerAlias.value
        : this.customerAlias,
    customerPhone: customerPhone.present
        ? customerPhone.value
        : this.customerPhone,
    status: status ?? this.status,
    total: total ?? this.total,
    itemCount: itemCount ?? this.itemCount,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    createdAt: createdAt ?? this.createdAt,
    paidAt: paidAt.present ? paidAt.value : this.paidAt,
  );
  OrderTableData copyWithCompanion(OrderTableCompanion data) {
    return OrderTableData(
      id: data.id.present ? data.id.value : this.id,
      customerAlias: data.customerAlias.present
          ? data.customerAlias.value
          : this.customerAlias,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      status: data.status.present ? data.status.value : this.status,
      total: data.total.present ? data.total.value : this.total,
      itemCount: data.itemCount.present ? data.itemCount.value : this.itemCount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderTableData(')
          ..write('id: $id, ')
          ..write('customerAlias: $customerAlias, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('status: $status, ')
          ..write('total: $total, ')
          ..write('itemCount: $itemCount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('createdAt: $createdAt, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerAlias,
    customerPhone,
    status,
    total,
    itemCount,
    paymentMethod,
    createdAt,
    paidAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderTableData &&
          other.id == this.id &&
          other.customerAlias == this.customerAlias &&
          other.customerPhone == this.customerPhone &&
          other.status == this.status &&
          other.total == this.total &&
          other.itemCount == this.itemCount &&
          other.paymentMethod == this.paymentMethod &&
          other.createdAt == this.createdAt &&
          other.paidAt == this.paidAt);
}

class OrderTableCompanion extends UpdateCompanion<OrderTableData> {
  final Value<String> id;
  final Value<String?> customerAlias;
  final Value<String?> customerPhone;
  final Value<String> status;
  final Value<int> total;
  final Value<int> itemCount;
  final Value<String?> paymentMethod;
  final Value<DateTime> createdAt;
  final Value<DateTime?> paidAt;
  final Value<int> rowid;
  const OrderTableCompanion({
    this.id = const Value.absent(),
    this.customerAlias = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.status = const Value.absent(),
    this.total = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderTableCompanion.insert({
    required String id,
    this.customerAlias = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.status = const Value.absent(),
    this.total = const Value.absent(),
    required int itemCount,
    this.paymentMethod = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemCount = Value(itemCount);
  static Insertable<OrderTableData> custom({
    Expression<String>? id,
    Expression<String>? customerAlias,
    Expression<String>? customerPhone,
    Expression<String>? status,
    Expression<int>? total,
    Expression<int>? itemCount,
    Expression<String>? paymentMethod,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? paidAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerAlias != null) 'customer_alias': customerAlias,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (status != null) 'status': status,
      if (total != null) 'total': total,
      if (itemCount != null) 'item_count': itemCount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (createdAt != null) 'created_at': createdAt,
      if (paidAt != null) 'paid_at': paidAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? customerAlias,
    Value<String?>? customerPhone,
    Value<String>? status,
    Value<int>? total,
    Value<int>? itemCount,
    Value<String?>? paymentMethod,
    Value<DateTime>? createdAt,
    Value<DateTime?>? paidAt,
    Value<int>? rowid,
  }) {
    return OrderTableCompanion(
      id: id ?? this.id,
      customerAlias: customerAlias ?? this.customerAlias,
      customerPhone: customerPhone ?? this.customerPhone,
      status: status ?? this.status,
      total: total ?? this.total,
      itemCount: itemCount ?? this.itemCount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      paidAt: paidAt ?? this.paidAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerAlias.present) {
      map['customer_alias'] = Variable<String>(customerAlias.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (itemCount.present) {
      map['item_count'] = Variable<int>(itemCount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderTableCompanion(')
          ..write('id: $id, ')
          ..write('customerAlias: $customerAlias, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('status: $status, ')
          ..write('total: $total, ')
          ..write('itemCount: $itemCount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('createdAt: $createdAt, ')
          ..write('paidAt: $paidAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTableTable extends OrderItemsTable
    with TableInfo<$OrderItemsTableTable, OrderItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES order_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _menuItemIdMeta = const VerificationMeta(
    'menuItemId',
  );
  @override
  late final GeneratedColumn<String> menuItemId = GeneratedColumn<String>(
    'menu_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    menuItemId,
    itemName,
    emoji,
    price,
    quantity,
    subtotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('menu_item_id')) {
      context.handle(
        _menuItemIdMeta,
        menuItemId.isAcceptableOrUnknown(
          data['menu_item_id']!,
          _menuItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_menuItemIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  OrderItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      menuItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}menu_item_id'],
      )!,
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal'],
      )!,
    );
  }

  @override
  $OrderItemsTableTable createAlias(String alias) {
    return $OrderItemsTableTable(attachedDatabase, alias);
  }
}

class OrderItemsTableData extends DataClass
    implements Insertable<OrderItemsTableData> {
  final String id;
  final String orderId;
  final String menuItemId;
  final String itemName;
  final String emoji;
  final int price;
  final int quantity;
  final int subtotal;
  const OrderItemsTableData({
    required this.id,
    required this.orderId,
    required this.menuItemId,
    required this.itemName,
    required this.emoji,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_id'] = Variable<String>(orderId);
    map['menu_item_id'] = Variable<String>(menuItemId);
    map['item_name'] = Variable<String>(itemName);
    map['emoji'] = Variable<String>(emoji);
    map['price'] = Variable<int>(price);
    map['quantity'] = Variable<int>(quantity);
    map['subtotal'] = Variable<int>(subtotal);
    return map;
  }

  OrderItemsTableCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsTableCompanion(
      id: Value(id),
      orderId: Value(orderId),
      menuItemId: Value(menuItemId),
      itemName: Value(itemName),
      emoji: Value(emoji),
      price: Value(price),
      quantity: Value(quantity),
      subtotal: Value(subtotal),
    );
  }

  factory OrderItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      menuItemId: serializer.fromJson<String>(json['menuItemId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      emoji: serializer.fromJson<String>(json['emoji']),
      price: serializer.fromJson<int>(json['price']),
      quantity: serializer.fromJson<int>(json['quantity']),
      subtotal: serializer.fromJson<int>(json['subtotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderId': serializer.toJson<String>(orderId),
      'menuItemId': serializer.toJson<String>(menuItemId),
      'itemName': serializer.toJson<String>(itemName),
      'emoji': serializer.toJson<String>(emoji),
      'price': serializer.toJson<int>(price),
      'quantity': serializer.toJson<int>(quantity),
      'subtotal': serializer.toJson<int>(subtotal),
    };
  }

  OrderItemsTableData copyWith({
    String? id,
    String? orderId,
    String? menuItemId,
    String? itemName,
    String? emoji,
    int? price,
    int? quantity,
    int? subtotal,
  }) => OrderItemsTableData(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    menuItemId: menuItemId ?? this.menuItemId,
    itemName: itemName ?? this.itemName,
    emoji: emoji ?? this.emoji,
    price: price ?? this.price,
    quantity: quantity ?? this.quantity,
    subtotal: subtotal ?? this.subtotal,
  );
  OrderItemsTableData copyWithCompanion(OrderItemsTableCompanion data) {
    return OrderItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      menuItemId: data.menuItemId.present
          ? data.menuItemId.value
          : this.menuItemId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      price: data.price.present ? data.price.value : this.price,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsTableData(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('itemName: $itemName, ')
          ..write('emoji: $emoji, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderId,
    menuItemId,
    itemName,
    emoji,
    price,
    quantity,
    subtotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemsTableData &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.menuItemId == this.menuItemId &&
          other.itemName == this.itemName &&
          other.emoji == this.emoji &&
          other.price == this.price &&
          other.quantity == this.quantity &&
          other.subtotal == this.subtotal);
}

class OrderItemsTableCompanion extends UpdateCompanion<OrderItemsTableData> {
  final Value<String> id;
  final Value<String> orderId;
  final Value<String> menuItemId;
  final Value<String> itemName;
  final Value<String> emoji;
  final Value<int> price;
  final Value<int> quantity;
  final Value<int> subtotal;
  final Value<int> rowid;
  const OrderItemsTableCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.menuItemId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.emoji = const Value.absent(),
    this.price = const Value.absent(),
    this.quantity = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderItemsTableCompanion.insert({
    required String id,
    required String orderId,
    required String menuItemId,
    required String itemName,
    required String emoji,
    required int price,
    required int quantity,
    required int subtotal,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orderId = Value(orderId),
       menuItemId = Value(menuItemId),
       itemName = Value(itemName),
       emoji = Value(emoji),
       price = Value(price),
       quantity = Value(quantity),
       subtotal = Value(subtotal);
  static Insertable<OrderItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? orderId,
    Expression<String>? menuItemId,
    Expression<String>? itemName,
    Expression<String>? emoji,
    Expression<int>? price,
    Expression<int>? quantity,
    Expression<int>? subtotal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (menuItemId != null) 'menu_item_id': menuItemId,
      if (itemName != null) 'item_name': itemName,
      if (emoji != null) 'emoji': emoji,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
      if (subtotal != null) 'subtotal': subtotal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? orderId,
    Value<String>? menuItemId,
    Value<String>? itemName,
    Value<String>? emoji,
    Value<int>? price,
    Value<int>? quantity,
    Value<int>? subtotal,
    Value<int>? rowid,
  }) {
    return OrderItemsTableCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      menuItemId: menuItemId ?? this.menuItemId,
      itemName: itemName ?? this.itemName,
      emoji: emoji ?? this.emoji,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (menuItemId.present) {
      map['menu_item_id'] = Variable<String>(menuItemId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('itemName: $itemName, ')
          ..write('emoji: $emoji, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('subtotal: $subtotal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CartDraftItemTableTable extends CartDraftItemTable
    with TableInfo<$CartDraftItemTableTable, CartDraftItemTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartDraftItemTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cartDraftIdMeta = const VerificationMeta(
    'cartDraftId',
  );
  @override
  late final GeneratedColumn<String> cartDraftId = GeneratedColumn<String>(
    'cart_draft_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _menuItemIdMeta = const VerificationMeta(
    'menuItemId',
  );
  @override
  late final GeneratedColumn<String> menuItemId = GeneratedColumn<String>(
    'menu_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPricePaiseMeta = const VerificationMeta(
    'unitPricePaise',
  );
  @override
  late final GeneratedColumn<int> unitPricePaise = GeneratedColumn<int>(
    'unit_price_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cartDraftId,
    menuItemId,
    itemName,
    quantity,
    unitPricePaise,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cart_draft_item_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CartDraftItemTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cart_draft_id')) {
      context.handle(
        _cartDraftIdMeta,
        cartDraftId.isAcceptableOrUnknown(
          data['cart_draft_id']!,
          _cartDraftIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cartDraftIdMeta);
    }
    if (data.containsKey('menu_item_id')) {
      context.handle(
        _menuItemIdMeta,
        menuItemId.isAcceptableOrUnknown(
          data['menu_item_id']!,
          _menuItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_menuItemIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price_paise')) {
      context.handle(
        _unitPricePaiseMeta,
        unitPricePaise.isAcceptableOrUnknown(
          data['unit_price_paise']!,
          _unitPricePaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPricePaiseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CartDraftItemTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartDraftItemTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cartDraftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cart_draft_id'],
      )!,
      menuItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}menu_item_id'],
      )!,
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitPricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_paise'],
      )!,
    );
  }

  @override
  $CartDraftItemTableTable createAlias(String alias) {
    return $CartDraftItemTableTable(attachedDatabase, alias);
  }
}

class CartDraftItemTableData extends DataClass
    implements Insertable<CartDraftItemTableData> {
  final String id;
  final String cartDraftId;
  final String menuItemId;
  final String itemName;
  final int quantity;
  final int unitPricePaise;
  const CartDraftItemTableData({
    required this.id,
    required this.cartDraftId,
    required this.menuItemId,
    required this.itemName,
    required this.quantity,
    required this.unitPricePaise,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cart_draft_id'] = Variable<String>(cartDraftId);
    map['menu_item_id'] = Variable<String>(menuItemId);
    map['item_name'] = Variable<String>(itemName);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price_paise'] = Variable<int>(unitPricePaise);
    return map;
  }

  CartDraftItemTableCompanion toCompanion(bool nullToAbsent) {
    return CartDraftItemTableCompanion(
      id: Value(id),
      cartDraftId: Value(cartDraftId),
      menuItemId: Value(menuItemId),
      itemName: Value(itemName),
      quantity: Value(quantity),
      unitPricePaise: Value(unitPricePaise),
    );
  }

  factory CartDraftItemTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartDraftItemTableData(
      id: serializer.fromJson<String>(json['id']),
      cartDraftId: serializer.fromJson<String>(json['cartDraftId']),
      menuItemId: serializer.fromJson<String>(json['menuItemId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPricePaise: serializer.fromJson<int>(json['unitPricePaise']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cartDraftId': serializer.toJson<String>(cartDraftId),
      'menuItemId': serializer.toJson<String>(menuItemId),
      'itemName': serializer.toJson<String>(itemName),
      'quantity': serializer.toJson<int>(quantity),
      'unitPricePaise': serializer.toJson<int>(unitPricePaise),
    };
  }

  CartDraftItemTableData copyWith({
    String? id,
    String? cartDraftId,
    String? menuItemId,
    String? itemName,
    int? quantity,
    int? unitPricePaise,
  }) => CartDraftItemTableData(
    id: id ?? this.id,
    cartDraftId: cartDraftId ?? this.cartDraftId,
    menuItemId: menuItemId ?? this.menuItemId,
    itemName: itemName ?? this.itemName,
    quantity: quantity ?? this.quantity,
    unitPricePaise: unitPricePaise ?? this.unitPricePaise,
  );
  CartDraftItemTableData copyWithCompanion(CartDraftItemTableCompanion data) {
    return CartDraftItemTableData(
      id: data.id.present ? data.id.value : this.id,
      cartDraftId: data.cartDraftId.present
          ? data.cartDraftId.value
          : this.cartDraftId,
      menuItemId: data.menuItemId.present
          ? data.menuItemId.value
          : this.menuItemId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPricePaise: data.unitPricePaise.present
          ? data.unitPricePaise.value
          : this.unitPricePaise,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CartDraftItemTableData(')
          ..write('id: $id, ')
          ..write('cartDraftId: $cartDraftId, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPricePaise: $unitPricePaise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cartDraftId,
    menuItemId,
    itemName,
    quantity,
    unitPricePaise,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartDraftItemTableData &&
          other.id == this.id &&
          other.cartDraftId == this.cartDraftId &&
          other.menuItemId == this.menuItemId &&
          other.itemName == this.itemName &&
          other.quantity == this.quantity &&
          other.unitPricePaise == this.unitPricePaise);
}

class CartDraftItemTableCompanion
    extends UpdateCompanion<CartDraftItemTableData> {
  final Value<String> id;
  final Value<String> cartDraftId;
  final Value<String> menuItemId;
  final Value<String> itemName;
  final Value<int> quantity;
  final Value<int> unitPricePaise;
  final Value<int> rowid;
  const CartDraftItemTableCompanion({
    this.id = const Value.absent(),
    this.cartDraftId = const Value.absent(),
    this.menuItemId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPricePaise = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CartDraftItemTableCompanion.insert({
    required String id,
    required String cartDraftId,
    required String menuItemId,
    required String itemName,
    required int quantity,
    required int unitPricePaise,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cartDraftId = Value(cartDraftId),
       menuItemId = Value(menuItemId),
       itemName = Value(itemName),
       quantity = Value(quantity),
       unitPricePaise = Value(unitPricePaise);
  static Insertable<CartDraftItemTableData> custom({
    Expression<String>? id,
    Expression<String>? cartDraftId,
    Expression<String>? menuItemId,
    Expression<String>? itemName,
    Expression<int>? quantity,
    Expression<int>? unitPricePaise,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cartDraftId != null) 'cart_draft_id': cartDraftId,
      if (menuItemId != null) 'menu_item_id': menuItemId,
      if (itemName != null) 'item_name': itemName,
      if (quantity != null) 'quantity': quantity,
      if (unitPricePaise != null) 'unit_price_paise': unitPricePaise,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CartDraftItemTableCompanion copyWith({
    Value<String>? id,
    Value<String>? cartDraftId,
    Value<String>? menuItemId,
    Value<String>? itemName,
    Value<int>? quantity,
    Value<int>? unitPricePaise,
    Value<int>? rowid,
  }) {
    return CartDraftItemTableCompanion(
      id: id ?? this.id,
      cartDraftId: cartDraftId ?? this.cartDraftId,
      menuItemId: menuItemId ?? this.menuItemId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unitPricePaise: unitPricePaise ?? this.unitPricePaise,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cartDraftId.present) {
      map['cart_draft_id'] = Variable<String>(cartDraftId.value);
    }
    if (menuItemId.present) {
      map['menu_item_id'] = Variable<String>(menuItemId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPricePaise.present) {
      map['unit_price_paise'] = Variable<int>(unitPricePaise.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartDraftItemTableCompanion(')
          ..write('id: $id, ')
          ..write('cartDraftId: $cartDraftId, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPricePaise: $unitPricePaise, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CartDraftTableTable extends CartDraftTable
    with TableInfo<$CartDraftTableTable, CartDraftTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartDraftTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerAliasMeta = const VerificationMeta(
    'customerAlias',
  );
  @override
  late final GeneratedColumn<String> customerAlias = GeneratedColumn<String>(
    'customer_alias',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerAlias,
    description,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cart_draft_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CartDraftTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_alias')) {
      context.handle(
        _customerAliasMeta,
        customerAlias.isAcceptableOrUnknown(
          data['customer_alias']!,
          _customerAliasMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CartDraftTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartDraftTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerAlias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_alias'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CartDraftTableTable createAlias(String alias) {
    return $CartDraftTableTable(attachedDatabase, alias);
  }
}

class CartDraftTableData extends DataClass
    implements Insertable<CartDraftTableData> {
  final String id;
  final String? customerAlias;
  final String? description;
  final DateTime updatedAt;
  const CartDraftTableData({
    required this.id,
    this.customerAlias,
    this.description,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || customerAlias != null) {
      map['customer_alias'] = Variable<String>(customerAlias);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CartDraftTableCompanion toCompanion(bool nullToAbsent) {
    return CartDraftTableCompanion(
      id: Value(id),
      customerAlias: customerAlias == null && nullToAbsent
          ? const Value.absent()
          : Value(customerAlias),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      updatedAt: Value(updatedAt),
    );
  }

  factory CartDraftTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartDraftTableData(
      id: serializer.fromJson<String>(json['id']),
      customerAlias: serializer.fromJson<String?>(json['customerAlias']),
      description: serializer.fromJson<String?>(json['description']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerAlias': serializer.toJson<String?>(customerAlias),
      'description': serializer.toJson<String?>(description),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CartDraftTableData copyWith({
    String? id,
    Value<String?> customerAlias = const Value.absent(),
    Value<String?> description = const Value.absent(),
    DateTime? updatedAt,
  }) => CartDraftTableData(
    id: id ?? this.id,
    customerAlias: customerAlias.present
        ? customerAlias.value
        : this.customerAlias,
    description: description.present ? description.value : this.description,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CartDraftTableData copyWithCompanion(CartDraftTableCompanion data) {
    return CartDraftTableData(
      id: data.id.present ? data.id.value : this.id,
      customerAlias: data.customerAlias.present
          ? data.customerAlias.value
          : this.customerAlias,
      description: data.description.present
          ? data.description.value
          : this.description,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CartDraftTableData(')
          ..write('id: $id, ')
          ..write('customerAlias: $customerAlias, ')
          ..write('description: $description, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, customerAlias, description, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartDraftTableData &&
          other.id == this.id &&
          other.customerAlias == this.customerAlias &&
          other.description == this.description &&
          other.updatedAt == this.updatedAt);
}

class CartDraftTableCompanion extends UpdateCompanion<CartDraftTableData> {
  final Value<String> id;
  final Value<String?> customerAlias;
  final Value<String?> description;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CartDraftTableCompanion({
    this.id = const Value.absent(),
    this.customerAlias = const Value.absent(),
    this.description = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CartDraftTableCompanion.insert({
    required String id,
    this.customerAlias = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt);
  static Insertable<CartDraftTableData> custom({
    Expression<String>? id,
    Expression<String>? customerAlias,
    Expression<String>? description,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerAlias != null) 'customer_alias': customerAlias,
      if (description != null) 'description': description,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CartDraftTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? customerAlias,
    Value<String?>? description,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CartDraftTableCompanion(
      id: id ?? this.id,
      customerAlias: customerAlias ?? this.customerAlias,
      description: description ?? this.description,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerAlias.present) {
      map['customer_alias'] = Variable<String>(customerAlias.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartDraftTableCompanion(')
          ..write('id: $id, ')
          ..write('customerAlias: $customerAlias, ')
          ..write('description: $description, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MenuItemTableTable menuItemTable = $MenuItemTableTable(this);
  late final $OrderTableTable orderTable = $OrderTableTable(this);
  late final $OrderItemsTableTable orderItemsTable = $OrderItemsTableTable(
    this,
  );
  late final $CartDraftItemTableTable cartDraftItemTable =
      $CartDraftItemTableTable(this);
  late final $CartDraftTableTable cartDraftTable = $CartDraftTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    menuItemTable,
    orderTable,
    orderItemsTable,
    cartDraftItemTable,
    cartDraftTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'order_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('order_items_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$MenuItemTableTableCreateCompanionBuilder =
    MenuItemTableCompanion Function({
      required String id,
      required String name,
      Value<bool> isActive,
      required List<int> prices,
      required String icon,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
    });
typedef $$MenuItemTableTableUpdateCompanionBuilder =
    MenuItemTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<bool> isActive,
      Value<List<int>> prices,
      Value<String> icon,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
    });

class $$MenuItemTableTableFilterComposer
    extends Composer<_$AppDatabase, $MenuItemTableTable> {
  $$MenuItemTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<int>, List<int>, String> get prices =>
      $composableBuilder(
        column: $table.prices,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MenuItemTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MenuItemTableTable> {
  $$MenuItemTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prices => $composableBuilder(
    column: $table.prices,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MenuItemTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MenuItemTableTable> {
  $$MenuItemTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>, String> get prices =>
      $composableBuilder(column: $table.prices, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MenuItemTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MenuItemTableTable,
          MenuItemTableData,
          $$MenuItemTableTableFilterComposer,
          $$MenuItemTableTableOrderingComposer,
          $$MenuItemTableTableAnnotationComposer,
          $$MenuItemTableTableCreateCompanionBuilder,
          $$MenuItemTableTableUpdateCompanionBuilder,
          (
            MenuItemTableData,
            BaseReferences<
              _$AppDatabase,
              $MenuItemTableTable,
              MenuItemTableData
            >,
          ),
          MenuItemTableData,
          PrefetchHooks Function()
        > {
  $$MenuItemTableTableTableManager(_$AppDatabase db, $MenuItemTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenuItemTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenuItemTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenuItemTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<List<int>> prices = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MenuItemTableCompanion(
                id: id,
                name: name,
                isActive: isActive,
                prices: prices,
                icon: icon,
                description: description,
                imageUrl: imageUrl,
                displayOrder: displayOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<bool> isActive = const Value.absent(),
                required List<int> prices,
                required String icon,
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MenuItemTableCompanion.insert(
                id: id,
                name: name,
                isActive: isActive,
                prices: prices,
                icon: icon,
                description: description,
                imageUrl: imageUrl,
                displayOrder: displayOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MenuItemTableTable, MenuItemTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MenuItemTableTable,
                    MenuItemTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MenuItemTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MenuItemTableTable,
      MenuItemTableData,
      $$MenuItemTableTableFilterComposer,
      $$MenuItemTableTableOrderingComposer,
      $$MenuItemTableTableAnnotationComposer,
      $$MenuItemTableTableCreateCompanionBuilder,
      $$MenuItemTableTableUpdateCompanionBuilder,
      (
        MenuItemTableData,
        BaseReferences<_$AppDatabase, $MenuItemTableTable, MenuItemTableData>,
      ),
      MenuItemTableData,
      PrefetchHooks Function()
    >;
typedef $$OrderTableTableCreateCompanionBuilder = OrderTableCompanion Function({
  required String id,
  Value<String?> customerAlias,
  Value<String?> customerPhone,
  Value<String> status,
  Value<int> total,
  required int itemCount,
  Value<String?> paymentMethod,
  Value<DateTime> createdAt,
  Value<DateTime?> paidAt,
  Value<int> rowid,
});
typedef $$OrderTableTableUpdateCompanionBuilder = OrderTableCompanion Function({
  Value<String> id,
  Value<String?> customerAlias,
  Value<String?> customerPhone,
  Value<String> status,
  Value<int> total,
  Value<int> itemCount,
  Value<String?> paymentMethod,
  Value<DateTime> createdAt,
  Value<DateTime?> paidAt,
  Value<int> rowid,
});

final class $$OrderTableTableReferences
    extends BaseReferences<_$AppDatabase, $OrderTableTable, OrderTableData> {
  $$OrderTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsTableTable, List<OrderItemsTableData>>
  _orderItemsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItemsTable,
    aliasName: 'order_table__id__order_items_table__order_id',
  );

  $$OrderItemsTableTableProcessedTableManager get orderItemsTableRefs {
    final manager = $$OrderItemsTableTableTableManager(
      $_db,
      $_db.orderItemsTable,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _orderItemsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrderTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrderTableTable> {
  $$OrderTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerAlias => $composableBuilder(
    column: $table.customerAlias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemCount => $composableBuilder(
    column: $table.itemCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> orderItemsTableRefs(
    Expression<bool> Function($$OrderItemsTableTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemsTable,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.orderItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrderTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderTableTable> {
  $$OrderTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerAlias => $composableBuilder(
    column: $table.customerAlias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemCount => $composableBuilder(
    column: $table.itemCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrderTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderTableTable> {
  $$OrderTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerAlias => $composableBuilder(
    column: $table.customerAlias,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  Expression<T> orderItemsTableRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemsTable,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrderTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderTableTable,
          OrderTableData,
          $$OrderTableTableFilterComposer,
          $$OrderTableTableOrderingComposer,
          $$OrderTableTableAnnotationComposer,
          $$OrderTableTableCreateCompanionBuilder,
          $$OrderTableTableUpdateCompanionBuilder,
          (OrderTableData, $$OrderTableTableReferences),
          OrderTableData,
          PrefetchHooks Function({bool orderItemsTableRefs})
        > {
  $$OrderTableTableTableManager(_$AppDatabase db, $OrderTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> customerAlias = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> itemCount = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderTableCompanion(
                id: id,
                customerAlias: customerAlias,
                customerPhone: customerPhone,
                status: status,
                total: total,
                itemCount: itemCount,
                paymentMethod: paymentMethod,
                createdAt: createdAt,
                paidAt: paidAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> customerAlias = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> total = const Value.absent(),
                required int itemCount,
                Value<String?> paymentMethod = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderTableCompanion.insert(
                id: id,
                customerAlias: customerAlias,
                customerPhone: customerPhone,
                status: status,
                total: total,
                itemCount: itemCount,
                paymentMethod: paymentMethod,
                createdAt: createdAt,
                paidAt: paidAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrderTableTable, OrderTableData>(table),
                  $$OrderTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderItemsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (orderItemsTableRefs) db.orderItemsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsTableRefs)
                    await $_getPrefetchedData<
                      OrderTableData,
                      $OrderTableTable,
                      OrderItemsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$OrderTableTableReferences
                          ._orderItemsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$OrderTableTableReferences(
                            db,
                            table,
                            p0,
                          ).orderItemsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.orderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$OrderTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderTableTable,
      OrderTableData,
      $$OrderTableTableFilterComposer,
      $$OrderTableTableOrderingComposer,
      $$OrderTableTableAnnotationComposer,
      $$OrderTableTableCreateCompanionBuilder,
      $$OrderTableTableUpdateCompanionBuilder,
      (OrderTableData, $$OrderTableTableReferences),
      OrderTableData,
      PrefetchHooks Function({bool orderItemsTableRefs})
    >;
typedef $$OrderItemsTableTableCreateCompanionBuilder =
    OrderItemsTableCompanion Function({
      required String id,
      required String orderId,
      required String menuItemId,
      required String itemName,
      required String emoji,
      required int price,
      required int quantity,
      required int subtotal,
      Value<int> rowid,
    });
typedef $$OrderItemsTableTableUpdateCompanionBuilder =
    OrderItemsTableCompanion Function({
      Value<String> id,
      Value<String> orderId,
      Value<String> menuItemId,
      Value<String> itemName,
      Value<String> emoji,
      Value<int> price,
      Value<int> quantity,
      Value<int> subtotal,
      Value<int> rowid,
    });

final class $$OrderItemsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OrderItemsTableTable,
          OrderItemsTableData
        > {
  $$OrderItemsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrderTableTable _orderIdTable(_$AppDatabase db) =>
      db.orderTable.createAlias('order_items_table__order_id__order_table__id');

  $$OrderTableTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

    final manager = $$OrderTableTableTableManager(
      $_db,
      $_db.orderTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get menuItemId => $composableBuilder(
    column: $table.menuItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  $$OrderTableTableFilterComposer get orderId {
    final $$OrderTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orderTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderTableTableFilterComposer(
            $db: $db,
            $table: $db.orderTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get menuItemId => $composableBuilder(
    column: $table.menuItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrderTableTableOrderingComposer get orderId {
    final $$OrderTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orderTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderTableTableOrderingComposer(
            $db: $db,
            $table: $db.orderTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get menuItemId => $composableBuilder(
    column: $table.menuItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  $$OrderTableTableAnnotationComposer get orderId {
    final $$OrderTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orderTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderTableTableAnnotationComposer(
            $db: $db,
            $table: $db.orderTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderItemsTableTable,
          OrderItemsTableData,
          $$OrderItemsTableTableFilterComposer,
          $$OrderItemsTableTableOrderingComposer,
          $$OrderItemsTableTableAnnotationComposer,
          $$OrderItemsTableTableCreateCompanionBuilder,
          $$OrderItemsTableTableUpdateCompanionBuilder,
          (OrderItemsTableData, $$OrderItemsTableTableReferences),
          OrderItemsTableData,
          PrefetchHooks Function({bool orderId})
        > {
  $$OrderItemsTableTableTableManager(
    _$AppDatabase db,
    $OrderItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> menuItemId = const Value.absent(),
                Value<String> itemName = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderItemsTableCompanion(
                id: id,
                orderId: orderId,
                menuItemId: menuItemId,
                itemName: itemName,
                emoji: emoji,
                price: price,
                quantity: quantity,
                subtotal: subtotal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orderId,
                required String menuItemId,
                required String itemName,
                required String emoji,
                required int price,
                required int quantity,
                required int subtotal,
                Value<int> rowid = const Value.absent(),
              }) => OrderItemsTableCompanion.insert(
                id: id,
                orderId: orderId,
                menuItemId: menuItemId,
                itemName: itemName,
                emoji: emoji,
                price: price,
                quantity: quantity,
                subtotal: subtotal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrderItemsTableTable, OrderItemsTableData>(
                    table,
                  ),
                  $$OrderItemsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.orderId,
                        referencedTable: $$OrderItemsTableTableReferences
                            ._orderIdTable(db),
                        referencedColumn: $$OrderItemsTableTableReferences
                            ._orderIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrderItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderItemsTableTable,
      OrderItemsTableData,
      $$OrderItemsTableTableFilterComposer,
      $$OrderItemsTableTableOrderingComposer,
      $$OrderItemsTableTableAnnotationComposer,
      $$OrderItemsTableTableCreateCompanionBuilder,
      $$OrderItemsTableTableUpdateCompanionBuilder,
      (OrderItemsTableData, $$OrderItemsTableTableReferences),
      OrderItemsTableData,
      PrefetchHooks Function({bool orderId})
    >;
typedef $$CartDraftItemTableTableCreateCompanionBuilder =
    CartDraftItemTableCompanion Function({
      required String id,
      required String cartDraftId,
      required String menuItemId,
      required String itemName,
      required int quantity,
      required int unitPricePaise,
      Value<int> rowid,
    });
typedef $$CartDraftItemTableTableUpdateCompanionBuilder =
    CartDraftItemTableCompanion Function({
      Value<String> id,
      Value<String> cartDraftId,
      Value<String> menuItemId,
      Value<String> itemName,
      Value<int> quantity,
      Value<int> unitPricePaise,
      Value<int> rowid,
    });

class $$CartDraftItemTableTableFilterComposer
    extends Composer<_$AppDatabase, $CartDraftItemTableTable> {
  $$CartDraftItemTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cartDraftId => $composableBuilder(
    column: $table.cartDraftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get menuItemId => $composableBuilder(
    column: $table.menuItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CartDraftItemTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CartDraftItemTableTable> {
  $$CartDraftItemTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cartDraftId => $composableBuilder(
    column: $table.cartDraftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get menuItemId => $composableBuilder(
    column: $table.menuItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CartDraftItemTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartDraftItemTableTable> {
  $$CartDraftItemTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cartDraftId => $composableBuilder(
    column: $table.cartDraftId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get menuItemId => $composableBuilder(
    column: $table.menuItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => column,
  );
}

class $$CartDraftItemTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CartDraftItemTableTable,
          CartDraftItemTableData,
          $$CartDraftItemTableTableFilterComposer,
          $$CartDraftItemTableTableOrderingComposer,
          $$CartDraftItemTableTableAnnotationComposer,
          $$CartDraftItemTableTableCreateCompanionBuilder,
          $$CartDraftItemTableTableUpdateCompanionBuilder,
          (
            CartDraftItemTableData,
            BaseReferences<
              _$AppDatabase,
              $CartDraftItemTableTable,
              CartDraftItemTableData
            >,
          ),
          CartDraftItemTableData,
          PrefetchHooks Function()
        > {
  $$CartDraftItemTableTableTableManager(
    _$AppDatabase db,
    $CartDraftItemTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartDraftItemTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartDraftItemTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartDraftItemTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cartDraftId = const Value.absent(),
                Value<String> menuItemId = const Value.absent(),
                Value<String> itemName = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> unitPricePaise = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CartDraftItemTableCompanion(
                id: id,
                cartDraftId: cartDraftId,
                menuItemId: menuItemId,
                itemName: itemName,
                quantity: quantity,
                unitPricePaise: unitPricePaise,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cartDraftId,
                required String menuItemId,
                required String itemName,
                required int quantity,
                required int unitPricePaise,
                Value<int> rowid = const Value.absent(),
              }) => CartDraftItemTableCompanion.insert(
                id: id,
                cartDraftId: cartDraftId,
                menuItemId: menuItemId,
                itemName: itemName,
                quantity: quantity,
                unitPricePaise: unitPricePaise,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CartDraftItemTableTable, CartDraftItemTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CartDraftItemTableTable,
                    CartDraftItemTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CartDraftItemTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CartDraftItemTableTable,
      CartDraftItemTableData,
      $$CartDraftItemTableTableFilterComposer,
      $$CartDraftItemTableTableOrderingComposer,
      $$CartDraftItemTableTableAnnotationComposer,
      $$CartDraftItemTableTableCreateCompanionBuilder,
      $$CartDraftItemTableTableUpdateCompanionBuilder,
      (
        CartDraftItemTableData,
        BaseReferences<
          _$AppDatabase,
          $CartDraftItemTableTable,
          CartDraftItemTableData
        >,
      ),
      CartDraftItemTableData,
      PrefetchHooks Function()
    >;
typedef $$CartDraftTableTableCreateCompanionBuilder =
    CartDraftTableCompanion Function({
      required String id,
      Value<String?> customerAlias,
      Value<String?> description,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CartDraftTableTableUpdateCompanionBuilder =
    CartDraftTableCompanion Function({
      Value<String> id,
      Value<String?> customerAlias,
      Value<String?> description,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CartDraftTableTableFilterComposer
    extends Composer<_$AppDatabase, $CartDraftTableTable> {
  $$CartDraftTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerAlias => $composableBuilder(
    column: $table.customerAlias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CartDraftTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CartDraftTableTable> {
  $$CartDraftTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerAlias => $composableBuilder(
    column: $table.customerAlias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CartDraftTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartDraftTableTable> {
  $$CartDraftTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerAlias => $composableBuilder(
    column: $table.customerAlias,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CartDraftTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CartDraftTableTable,
          CartDraftTableData,
          $$CartDraftTableTableFilterComposer,
          $$CartDraftTableTableOrderingComposer,
          $$CartDraftTableTableAnnotationComposer,
          $$CartDraftTableTableCreateCompanionBuilder,
          $$CartDraftTableTableUpdateCompanionBuilder,
          (
            CartDraftTableData,
            BaseReferences<
              _$AppDatabase,
              $CartDraftTableTable,
              CartDraftTableData
            >,
          ),
          CartDraftTableData,
          PrefetchHooks Function()
        > {
  $$CartDraftTableTableTableManager(
    _$AppDatabase db,
    $CartDraftTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartDraftTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartDraftTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartDraftTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> customerAlias = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CartDraftTableCompanion(
                id: id,
                customerAlias: customerAlias,
                description: description,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> customerAlias = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CartDraftTableCompanion.insert(
                id: id,
                customerAlias: customerAlias,
                description: description,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CartDraftTableTable, CartDraftTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CartDraftTableTable,
                    CartDraftTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CartDraftTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CartDraftTableTable,
      CartDraftTableData,
      $$CartDraftTableTableFilterComposer,
      $$CartDraftTableTableOrderingComposer,
      $$CartDraftTableTableAnnotationComposer,
      $$CartDraftTableTableCreateCompanionBuilder,
      $$CartDraftTableTableUpdateCompanionBuilder,
      (
        CartDraftTableData,
        BaseReferences<_$AppDatabase, $CartDraftTableTable, CartDraftTableData>,
      ),
      CartDraftTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MenuItemTableTableTableManager get menuItemTable =>
      $$MenuItemTableTableTableManager(_db, _db.menuItemTable);
  $$OrderTableTableTableManager get orderTable =>
      $$OrderTableTableTableManager(_db, _db.orderTable);
  $$OrderItemsTableTableTableManager get orderItemsTable =>
      $$OrderItemsTableTableTableManager(_db, _db.orderItemsTable);
  $$CartDraftItemTableTableTableManager get cartDraftItemTable =>
      $$CartDraftItemTableTableTableManager(_db, _db.cartDraftItemTable);
  $$CartDraftTableTableTableManager get cartDraftTable =>
      $$CartDraftTableTableTableManager(_db, _db.cartDraftTable);
}
