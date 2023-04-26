// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LendersTable extends Lenders with TableInfo<$LendersTable, Lender> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LendersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<bool> paid =
      GeneratedColumn<bool>('paid', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("paid" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, name, date, paid];
  @override
  String get aliasedName => _alias ?? 'lenders';
  @override
  String get actualTableName => 'lenders';
  @override
  VerificationContext validateIntegrity(Insertable<Lender> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('paid')) {
      context.handle(
          _paidMeta, paid.isAcceptableOrUnknown(data['paid']!, _paidMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lender map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lender(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      paid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}paid'])!,
    );
  }

  @override
  $LendersTable createAlias(String alias) {
    return $LendersTable(attachedDatabase, alias);
  }
}

class Lender extends DataClass implements Insertable<Lender> {
  final int id;
  final String name;
  final String date;
  final bool paid;
  const Lender(
      {required this.id,
      required this.name,
      required this.date,
      required this.paid});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['date'] = Variable<String>(date);
    map['paid'] = Variable<bool>(paid);
    return map;
  }

  LendersCompanion toCompanion(bool nullToAbsent) {
    return LendersCompanion(
      id: Value(id),
      name: Value(name),
      date: Value(date),
      paid: Value(paid),
    );
  }

  factory Lender.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lender(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      date: serializer.fromJson<String>(json['date']),
      paid: serializer.fromJson<bool>(json['paid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'date': serializer.toJson<String>(date),
      'paid': serializer.toJson<bool>(paid),
    };
  }

  Lender copyWith({int? id, String? name, String? date, bool? paid}) => Lender(
        id: id ?? this.id,
        name: name ?? this.name,
        date: date ?? this.date,
        paid: paid ?? this.paid,
      );
  @override
  String toString() {
    return (StringBuffer('Lender(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('paid: $paid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, date, paid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lender &&
          other.id == this.id &&
          other.name == this.name &&
          other.date == this.date &&
          other.paid == this.paid);
}

class LendersCompanion extends UpdateCompanion<Lender> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> date;
  final Value<bool> paid;
  const LendersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.paid = const Value.absent(),
  });
  LendersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String date,
    this.paid = const Value.absent(),
  })  : name = Value(name),
        date = Value(date);
  static Insertable<Lender> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? date,
    Expression<bool>? paid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (paid != null) 'paid': paid,
    });
  }

  LendersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? date,
      Value<bool>? paid}) {
    return LendersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      paid: paid ?? this.paid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (paid.present) {
      map['paid'] = Variable<bool>(paid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LendersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('paid: $paid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
      'amount', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<String> quantity = GeneratedColumn<String>(
      'quantity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, amount, quantity];
  @override
  String get aliasedName => _alias ?? 'products';
  @override
  String get actualTableName => 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amount'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String amount;
  final String quantity;
  const Product(
      {required this.id,
      required this.name,
      required this.amount,
      required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<String>(amount);
    map['quantity'] = Variable<String>(quantity);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      quantity: Value(quantity),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<String>(json['amount']),
      quantity: serializer.fromJson<String>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<String>(amount),
      'quantity': serializer.toJson<String>(quantity),
    };
  }

  Product copyWith({int? id, String? name, String? amount, String? quantity}) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        quantity: quantity ?? this.quantity,
      );
  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amount, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.quantity == this.quantity);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> amount;
  final Value<String> quantity;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String amount,
    required String quantity,
  })  : name = Value(name),
        amount = Value(amount),
        quantity = Value(quantity);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? amount,
    Expression<String>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (quantity != null) 'quantity': quantity,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? amount,
      Value<String>? quantity}) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<String>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $LenderProductsTable extends LenderProducts
    with TableInfo<$LenderProductsTable, LenderProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LenderProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lenderMeta = const VerificationMeta('lender');
  @override
  late final GeneratedColumn<int> lender = GeneratedColumn<int>(
      'lender', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES lenders (id)'));
  static const VerificationMeta _productMeta =
      const VerificationMeta('product');
  @override
  late final GeneratedColumn<int> product = GeneratedColumn<int>(
      'product', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  @override
  List<GeneratedColumn> get $columns => [lender, product];
  @override
  String get aliasedName => _alias ?? 'lender_products';
  @override
  String get actualTableName => 'lender_products';
  @override
  VerificationContext validateIntegrity(Insertable<LenderProduct> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lender')) {
      context.handle(_lenderMeta,
          lender.isAcceptableOrUnknown(data['lender']!, _lenderMeta));
    } else if (isInserting) {
      context.missing(_lenderMeta);
    }
    if (data.containsKey('product')) {
      context.handle(_productMeta,
          product.isAcceptableOrUnknown(data['product']!, _productMeta));
    } else if (isInserting) {
      context.missing(_productMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  LenderProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LenderProduct(
      lender: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lender'])!,
      product: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product'])!,
    );
  }

  @override
  $LenderProductsTable createAlias(String alias) {
    return $LenderProductsTable(attachedDatabase, alias);
  }
}

class LenderProduct extends DataClass implements Insertable<LenderProduct> {
  final int lender;
  final int product;
  const LenderProduct({required this.lender, required this.product});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lender'] = Variable<int>(lender);
    map['product'] = Variable<int>(product);
    return map;
  }

  LenderProductsCompanion toCompanion(bool nullToAbsent) {
    return LenderProductsCompanion(
      lender: Value(lender),
      product: Value(product),
    );
  }

  factory LenderProduct.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LenderProduct(
      lender: serializer.fromJson<int>(json['lender']),
      product: serializer.fromJson<int>(json['product']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lender': serializer.toJson<int>(lender),
      'product': serializer.toJson<int>(product),
    };
  }

  LenderProduct copyWith({int? lender, int? product}) => LenderProduct(
        lender: lender ?? this.lender,
        product: product ?? this.product,
      );
  @override
  String toString() {
    return (StringBuffer('LenderProduct(')
          ..write('lender: $lender, ')
          ..write('product: $product')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lender, product);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LenderProduct &&
          other.lender == this.lender &&
          other.product == this.product);
}

class LenderProductsCompanion extends UpdateCompanion<LenderProduct> {
  final Value<int> lender;
  final Value<int> product;
  const LenderProductsCompanion({
    this.lender = const Value.absent(),
    this.product = const Value.absent(),
  });
  LenderProductsCompanion.insert({
    required int lender,
    required int product,
  })  : lender = Value(lender),
        product = Value(product);
  static Insertable<LenderProduct> custom({
    Expression<int>? lender,
    Expression<int>? product,
  }) {
    return RawValuesInsertable({
      if (lender != null) 'lender': lender,
      if (product != null) 'product': product,
    });
  }

  LenderProductsCompanion copyWith({Value<int>? lender, Value<int>? product}) {
    return LenderProductsCompanion(
      lender: lender ?? this.lender,
      product: product ?? this.product,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lender.present) {
      map['lender'] = Variable<int>(lender.value);
    }
    if (product.present) {
      map['product'] = Variable<int>(product.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LenderProductsCompanion(')
          ..write('lender: $lender, ')
          ..write('product: $product')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  late final $LendersTable lenders = $LendersTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $LenderProductsTable lenderProducts = $LenderProductsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [lenders, products, lenderProducts];
}
