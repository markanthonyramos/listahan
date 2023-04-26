import 'package:listahan/item_provider.dart' as item;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:listahan/lending_provider.dart' as lending;

class DatabaseHelper {
  Database? db;

  Future<Database> getDb() async {
    var dbPath = await getApplicationDocumentsDirectory();

    var path = join(dbPath.path, 'database.db');
    
    db ??= await initDb(path);

    return db!;
  }

  Future<Database> initDb(String path) async {
    db = await openDatabase(path, version: 1, 
      onCreate: (db, version) async {
        await db.execute(
          '''
            create table ${lending.tableLending}( 
              ${lending.columnId} integer primary key autoincrement, 
              ${lending.columnName} text not null,
              ${lending.columnAmount} text not null,
              ${lending.columnDate} text not null,
              ${lending.columnPaid} int not null
            );
          '''
        );

        await db.execute(
          '''
            create table ${item.tableProducts}( 
              ${item.columnId} integer primary key autoincrement, 
              ${item.columnName} text not null,
              ${item.columnAmount} text not null,
              ${item.columnQuantity} text not null
            );
          '''
        );
    });

    return db!;
  }

  Future close(Database db) async { 
    return await db.close();
  }
}