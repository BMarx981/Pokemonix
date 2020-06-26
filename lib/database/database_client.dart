import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBClient {
  Database _db;

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, 'database.db');

    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: this._create,
    );
  }

  Future _create(Database db, int version) async {
    await db.execute("""CREATE TABLE pokemon
      id INTEGER PRIMARY KEY,
      poke_name TEXT NOT NULL,
      evolutions TEXT NOT NULL,

    """);
  }
}
