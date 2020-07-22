import 'dart:io' show File, Platform;
import 'dart:async';
import 'package:flutter_app_todo/db/todo_table.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TodoDatabase {
  static const DB_NAME = 'todo.db';
  static const DB_VERSION = 1;
  static Database _database;

  static const initScripts = [TodoTable.CREATE_TABLE_QUERY];
  static const migrationScripts = [TodoTable.CREATE_TABLE_QUERY];

  TodoDatabase._privateConstructor();
  static final TodoDatabase instance = TodoDatabase._privateConstructor();

  Future<Database> get database async {
    if (_database == null) {
      _database = await init();
    }
    return _database;
  }

  Future<Database> init() async {
    if (Platform.isWindows) {
      //path to db file, at application folder
      final script = File(Platform.script.toFilePath());
      final file = File(p.join(script.parent.path, DB_NAME));
      if (!await file.exists()) {
        // create db file
        new File(file.path).create(recursive: true);
      }

      // Init ffi loader if needed.
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      var db = await databaseFactory.openDatabase(file.path,
          options: OpenDatabaseOptions(onCreate: (db, version) {
        initScripts.forEach((script) async => await db.execute(script));
      }, onUpgrade: (db, oldVersion, newVersion) {
        migrationScripts.forEach((script) async => await db.execute(script));
      }, version: DB_VERSION));

      await db.execute(TodoTable.CREATE_TABLE_QUERY);
      return db;
    } else {
      var databasesPath = await getDatabasesPath();
      String path = p.join(databasesPath, DB_NAME);
      var db = await openDatabase(path, onCreate: (db, version) {
        initScripts.forEach((script) async => await db.execute(script));
      }, onUpgrade: (db, oldVersion, newVersion) {
        migrationScripts.forEach((script) async => await db.execute(script));
      }, version: DB_VERSION);
      return db;
    }
  }
}
