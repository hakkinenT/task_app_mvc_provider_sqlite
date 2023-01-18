import 'package:sqflite/sqflite.dart';

import '../../../core/error/error.dart';
import '../../../models/models.dart';
import '../database.dart';

abstract class TaskDao {
  Future<List<Task>> getAll();
  Future<int> add(Task task);
  Future<int> delete(int taskId);
  Future<int> deleteAll();
  Future<int> update(Task task);
}

class TaskDaoImpl implements TaskDao {
  late Database db;

  @override
  Future<List<Task>> getAll() async {
    try {
      db = await DB.instance.database;
      var response = await db.query("task");
      List<Task> tasks = response.map((e) => Task.fromJson(e)).toList();

      return tasks;
    } on Exception {
      throw SqliteOperationException();
    }
  }

  @override
  Future<int> add(Task task) async {
    try {
      db = await DB.instance.database;

      final id = await db.insert("task", task.toJson());

      return id;
    } on Exception {
      throw SqliteOperationException();
    }
  }

  @override
  Future<int> update(Task task) async {
    try {
      db = await DB.instance.database;

      final raw = await db
          .update("task", task.toJson(), where: "id = ?", whereArgs: [task.id]);

      return raw;
    } on Exception {
      throw SqliteOperationException();
    }
  }

  @override
  Future<int> delete(int taskId) async {
    try {
      db = await DB.instance.database;

      final raw = await db.delete("task", where: "id = ?", whereArgs: [taskId]);

      return raw;
    } on Exception {
      throw SqliteOperationException();
    }
  }

  @override
  Future<int> deleteAll() async {
    try {
      db = await DB.instance.database;

      final raw = await db.delete("task");

      return raw;
    } on Exception {
      throw SqliteOperationException();
    }
  }
}
