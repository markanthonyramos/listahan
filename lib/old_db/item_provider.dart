import 'package:sqflite/sqflite.dart';

const String tableProducts = 'products';
const String columnId = '_id';
const String columnName = 'name';
const String columnAmount = 'amount';
const String columnQuantity = 'quantity';

class Product {
  int? id;
  late String name;
  late String amount;
  late String quantity;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnName: name,
      columnAmount: amount,
      columnQuantity: quantity,
    };

    if (id != null) {
      map[columnId] = id;
    }
    
    return map;
  }

  Product();

  Product.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int;
    name = map[columnName] as String;
    amount = map[columnAmount] as String;
    quantity = map[columnQuantity] as String;
  }
}

class ProductProvider {
  Future<Product> insert(Database db, Product product) async {
    product.id = await db.insert(tableProducts, product.toMap());

    return product;
  }

  Future<List<Product>> getAllRows(Database db) async {
    var query = await db.rawQuery('select * from $tableProducts;');

    if (query.isNotEmpty) {
      List<Product> productList = [];

      for (var i = 0; i < query.length; i++) {
        productList.add(Product.fromMap(query[i]));
      }
      
      return productList;
    }

    return [];
  }

  Future<Product?> getRow(Database db, int id) async {
    List<Map<String, Object?>> maps = await db.query(
        tableProducts,
        columns: [columnId, columnName, columnAmount, columnQuantity],
        where: '$columnId = ?',
        whereArgs: [id]
      );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }

    return null;
  }

  Future<int> delete(Database db, int id) async {
    return await db.delete(tableProducts, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Database db, Product product) async {
    return await db.update(tableProducts, product.toMap(),
        where: '$columnId = ?', whereArgs: [product.id]);
  }
}