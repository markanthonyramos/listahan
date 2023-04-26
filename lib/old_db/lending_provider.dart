import 'package:sqflite/sqflite.dart';

const String tableLending = 'lending';
const String columnId = '_id';
const String columnName = 'name';
const String columnAmount = 'amount';
const String columnDate = 'date';
const String columnPaid = "paid";

class Lending {
  int? id;
  late String name;
  late String amount;
  late String date;
  bool paid = false;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnName: name,
      columnAmount: amount,
      columnDate: date,
      columnPaid: paid == true ? 1 : 0,
    };

    if (id != null) {
      map[columnId] = id;
    }
    
    return map;
  }

  Lending();

  Lending.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int;
    name = map[columnName] as String;
    amount = map[columnAmount] as String;
    date = map[columnDate] as String;
    paid = map[columnPaid] == 1;
  }
}

class LendingProvider {
  Future<Lending> insert(Database db, Lending lending) async {
    lending.id = await db.insert(tableLending, lending.toMap());

    return lending;
  }

  Future<List<Lending>> getAllRows(Database db) async {
    var query = await db.rawQuery('select * from $tableLending;');

    if (query.isNotEmpty) {
      List<Lending> lendingList = [];

      for (var i = 0; i < query.length; i++) {
        lendingList.add(Lending.fromMap(query[i]));
      }
      
      return lendingList;
    }

    return [];
  }

  Future<List<Lending>> getAllRowsPending(Database db) async {
    var query = await db.rawQuery('select * from $tableLending where paid = 0;');

    if (query.isNotEmpty) {
      List<Lending> lendingList = [];

      for (var i = 0; i < query.length; i++) {
        lendingList.add(Lending.fromMap(query[i]));
      }
      
      return lendingList;
    }

    return [];
  }

  Future<List<Lending>> getAllRowsPaid(Database db) async {
    var query = await db.rawQuery('select * from $tableLending where paid = 1;');

    if (query.isNotEmpty) {
      List<Lending> lendingList = [];

      for (var i = 0; i < query.length; i++) {
        lendingList.add(Lending.fromMap(query[i]));
      }
      
      return lendingList;
    }

    return [];
  }

  Future<Lending?> getRow(Database db, int id) async {
    List<Map<String, Object?>> maps = await db.query(
        tableLending,
        columns: [columnId, columnName, columnAmount, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]
      );

    if (maps.isNotEmpty) {
      return Lending.fromMap(maps.first);
    }

    return null;
  }

  Future<int> delete(Database db, int id) async {
    return await db.delete(tableLending, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Database db, Lending lending) async {
    return await db.update(tableLending, lending.toMap(),
        where: '$columnId = ?', whereArgs: [lending.id]);
  }
}