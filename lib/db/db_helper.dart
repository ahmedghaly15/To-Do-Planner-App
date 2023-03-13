import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DBHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tableName = 'tasks';

//==================== Initialize Databasae ====================
  static Future<void> initDatabase() async {
    if (_database != null) {
      debugPrint("not null database");
      return;
    } else {
      try {
        String path = '${await getDatabasesPath()}task.db';
        debugPrint("in database path");
        _database = await openDatabase(path, version: _version,
            onCreate: (Database db, int version) {
          debugPrint("creating a new database");
          return db.execute('CREATE TABLE $_tableName('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'taskText TEXT, date STRING, '
              'startTime STRING, endTime STRING, '
              'remind INTEGER, repeat STRING, '
              'color INTEGER, '
              'isCompleted INTEGER)');
        });
        debugPrint("DATABASE CREATED");
      } catch (error) {
        print(error);
      }
    }
  }

//==================== Insert Data To Databasae ====================
  static Future<int> insert(Task? task) async {
    debugPrint("insert function called");
    try {
      return await _database!.insert(_tableName, task!.toJson());
    } catch (e) {
      print("Error Catched: $e");
      return 50505050;
    }
  }

//==================== Delete Data From Databasae ====================
  static Future<int> delete(Task task) async {
    debugPrint("delete function called");
    return await _database!
        .delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

//==================== Delete All Data From Databasae ====================
  static Future<int> deleteAll() async {
    debugPrint("delete all function called");
    return await _database!.delete(_tableName);
  }

//==================== The Table Data in Databasae ====================
  static Future<List<Map<String, Object?>>> query() async {
    debugPrint("query function called");
    return await _database!.query(_tableName);
  }

//==================== Update Data in Databasae ====================
  static Future<int> update(int id) async {
    debugPrint("update function called");
    return await _database!.rawUpdate('''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
    ''', [1, id]);
  }
}
