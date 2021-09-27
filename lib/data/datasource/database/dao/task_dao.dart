import 'package:hive_flutter/hive_flutter.dart';
import 'package:zanshin/data/model/task.dart';

class TaskDao {
  static const String _tableName = "task";

  Future<void> saveTask(Task task) async {
    final Box<Task> db = await Hive.openBox(_tableName);

    db.add(task);
  }

  Future<void> deleteTask(Task task) async => task.delete();

  Future<void> updateTask(Task task) async => task.save();

  Future<List<Task>> getAllTasks() async {
    final Box<Task> db = await Hive.openBox(_tableName);

    return db.values.toList(growable: false);
  }
}
