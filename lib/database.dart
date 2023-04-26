import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';

part 'database.g.dart';

class Lenders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get date => text()();
  BoolColumn get paid => boolean().withDefault(const Constant(false))();
}

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get amount => text()();
  TextColumn get quantity => text()();
}

class LenderProducts extends Table {
  IntColumn get lender => integer().references(Lenders, #id)();
  IntColumn get product => integer().references(Products, #id)();
}

class LenderWithProducts extends Table{
  final Lender lender;
  final List<Product> products;

  LenderWithProducts(this.lender, this.products);
}

@DriftDatabase(tables: [Lenders, Products, LenderProducts])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> addLenderWithProducts(LenderWithProducts entry) {
    return transaction(() async { 
      if (entry.products.isNotEmpty) {
        for (final product in entry.products) {
          await into(lenderProducts).insert(LenderProduct(lender: entry.lender.id, product: product.id));
        }
      }
    });
  }

  Future<void> updateLenderWithProducts(LenderWithProducts entry) async {
    await updateLender(entry.lender);
    
    await (delete(lenderProducts)..where((t) => t.lender.equals(entry.lender.id))).go();
    
    return transaction(() async { 
      if (entry.products.isNotEmpty) {
        for (final product in entry.products) {
          await into(lenderProducts).insert(LenderProduct(lender: entry.lender.id, product: product.id));
        }
      }
    });
  }

  Stream<List<LenderWithProducts>> getLendersPaid() {
    final lenderStream = (select(lenders)..where((t) => t.paid.equals(true))..orderBy([(t) => OrderingTerm.desc(t.id)])).watch();

    return lenderStream.switchMap((lenders) {
      final idToLender = {for (var lender in lenders) lender.id: lender};
      final ids = idToLender.keys;

      final joinQuery = select(lenderProducts).join([
        innerJoin(products, products.id.equalsExp(lenderProducts.product))
      ])..where(lenderProducts.lender.isIn(ids));

      return joinQuery.watch().map((rows) {
        final idToProducts = <int, List<Product>>{};

        for (final row in rows) {
          final product = row.readTable(products);
          final id = row.readTable(lenderProducts).lender;

          idToProducts.putIfAbsent(id, () => []).add(product);
        }

        return [
          for (var id in ids) LenderWithProducts(idToLender[id]!, idToProducts[id] ?? []),
        ];
      });
    }); 
  }

  Stream<List<LenderWithProducts>> getLendersPending() {
    final lenderStream = (select(lenders)..where((t) => t.paid.equals(false))..orderBy([(t) => OrderingTerm.desc(t.id)])).watch();

    return lenderStream.switchMap((lenders) {
      final idToLender = {for (var lender in lenders) lender.id: lender};
      final ids = idToLender.keys;

      final joinQuery = select(lenderProducts).join([
        innerJoin(products, products.id.equalsExp(lenderProducts.product))
      ])..where(lenderProducts.lender.isIn(ids));

      return joinQuery.watch().map((rows) {
        final idToProducts = <int, List<Product>>{};

        for (final row in rows) {
          final product = row.readTable(products);
          final id = row.readTable(lenderProducts).lender;

          idToProducts.putIfAbsent(id, () => []).add(product);
        }

        return [
          for (var id in ids) LenderWithProducts(idToLender[id]!, idToProducts[id] ?? []),
        ];
      });
    });
  }

  Future<List<Lender>> getAllLenders() {
    return select(lenders).get();
  }

  Future<Lender> getLender(int id) {
    return (select(lenders)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<Lender> addLender(LendersCompanion entry) {
    return into(lenders).insert(entry).then((id) => getLender(id));
  }

  Future<bool> updateLender(Lender entry) {
    return update(lenders).replace(entry);
  }

  Future<int> deleteLender(int id) async {
    await (delete(lenders)..where((t) => t.id.equals(id))).go();

    return (delete(lenderProducts)..where((t) => t.lender.equals(id))).go();
  }

  Future<List<Product>> getAllProducts() {
    return select(products).get();
  }

  Future<List<Product>> getProduct(int id) {
    return (select(products)..where((t) => t.id.equals(id))).get();
  }

  Future<List<Product>> getProductThatContains(String name) {
    return (select(products)..where((t) => t.name.contains(name))).get();
  }

  Future<int> addProduct(ProductsCompanion entry) {
    return into(products).insert(entry);
  }

  Future<bool> updateProduct(Product entry) {
    return update(products).replace(entry);
  }

  Future<int> deleteProduct(int id) {
    return (delete(products)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'database.db'));
    return NativeDatabase.createInBackground(file);
  });
}