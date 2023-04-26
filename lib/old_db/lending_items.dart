import 'package:listahan/product_provider.dart';
import 'package:listahan/lending_provider.dart';
import 'package:sqflite/sqflite.dart';

const String tableLendingProduct = 'lending_product';
const String columnId = '_id';
const String columnLendingId = 'lending_id';
const String columnProductId = 'product_id';

class LendingProduct {
  int? id;
  late Lending lending;
  late List<Product> products;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnLendingId: name,
      columnLendingId: amount,
      columnQuantity: quantity,
    };

    if (id != null) {
      map[columnId] = id;
    }
    
    return map;
  }

  Item();

  Item.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int;
    name = map[columnName] as String;
    amount = map[columnAmount] as String;
    quantity = map[columnQuantity] as String;
  }
}

class ItemProvider {
  Future<Item> insert(Database db, Item item) async {
    item.id = await db.insert(tableItems, item.toMap());

    return item;
  }

  Future<List<Item>> getAllRows(Database db) async {
    var query = await db.rawQuery('select * from $tableItems;');

    if (query.isNotEmpty) {
      List<Item> itemList = [];

      for (var i = 0; i < query.length; i++) {
        itemList.add(Item.fromMap(query[i]));
      }
      
      return itemList;
    }

    return [];
  }

  Future<Item?> getRow(Database db, int id) async {
    List<Map<String, Object?>> maps = await db.query(
        tableItems,
        columns: [columnId, columnName, columnAmount, columnQuantity],
        where: '$columnId = ?',
        whereArgs: [id]
      );

    if (maps.isNotEmpty) {
      return Item.fromMap(maps.first);
    }

    return null;
  }

  Future<int> delete(Database db, int id) async {
    return await db.delete(tableItems, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Database db, Item item) async {
    return await db.update(tableItems, item.toMap(),
        where: '$columnId = ?', whereArgs: [item.id]);
  }
}