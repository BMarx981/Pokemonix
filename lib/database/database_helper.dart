import 'dart:core';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final String dbName = 'pokemon.db';
  final int version = 1;

  final String table = 'pokeTable';

  final String colId = 'id';
  final String colName = 'name';
  final String colEvolutions = 'evolutions';
  final String colAbilities = 'abilities';
  final String colMoves = 'moves';

  static Database _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    return await openDatabase(path, version: version, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $colId INTEGER PRIMARY KEY,
            $colName TEXT NOT NULL,
            $colEvolutions TEXT NOT NULL,
            $colAbilities TEXT NOT NULL,
            $colMoves TEXT NOT NULL,
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[colId];
    return await db.update(table, row, where: '$colId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$colId = ?', whereArgs: [id]);
  }
}
