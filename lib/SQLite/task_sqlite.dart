import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../JsonModels/task_model.dart';

class DataBaseHelperTasks {
    static Database? database;
  final databaseName = "task.db";

    // tasks database

  Future<Database> getTaskDb() async {
    if (database == null) {
      database =
          await openDatabase(join(await getDatabasesPath(), databaseName),
              onCreate: (db, version) {
       
        db.execute(TaskModel.taskTableCreate);

        log('******************OnCreate Tasks ^^^^^^^^^^^^^^^^^^^^^^^^^ ');
      }, onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion != newVersion) {
          db.execute(TaskModel.dropTabletask);
          db.execute(TaskModel.taskTableCreate);
          
        }
      }, version: 1);
      return Future.value(database);
    }
    return Future.value(database);
  }

   // search tasks
  Future<List<TaskModel>> searchtasks(String search) async {
    final Database database = await getTaskDb();
    List<Map<String, Object?>> searchResult = await database.rawQuery(
        "select * from ${TaskModel.tasktableName} where taskTitle LIKE ?",
        ["%$search%"]);
    return searchResult.map((e) => TaskModel.fromMap(e)).toList();
  }


 // create tasks method
  Future<bool> createtask(TaskModel task) async {
    try {
      Database? database = await getTaskDb();
      int result = await database.insert(
        TaskModel.tasktableName,
        task.toMap(task),
      );
      log('*************************Create Task data*******************');

      if (result < 0) {
        return false;
      }
      return true;
    } catch (e) {
      log("insertData Error : $e");
      return false;
    }
  }

   // Get tasks
 Future<List<TaskModel>> fetchTaskData() async {
  try {
    Database? database = await getTaskDb();
    log("$database");
    // String createTableQuery =
    //     'SELECT name FROM sqlite_master WHERE type = "table" AND name = "${TaskModel.tasktableName}"';
    // List<Map<String, dynamic>> results = await database.rawQuery(createTableQuery);

    // if (results.isEmpty) {
    //   await database.execute(TaskModel.taskTableCreate);
    //   log('Created task table');
    // } else {
    //   log('Task table already exists');
    // }

    List<Map<String, dynamic>> tasks = await database.rawQuery(TaskModel.fetch_task);
    log('Fetched ${tasks.length} tasks from the database');
    
    return tasks.map((map) => TaskModel.fromMap(map)).toList();
   
  } catch (e) {
    log("fetch task data Error: $e");
    return []; // Return an empty list on error
  }
}
  // delete one task from database
  Future<bool> daleteOneTaskItem(int id) async {
    try {
      Database? database = await getTaskDb();
      int rows = await database.delete(TaskModel.tasktableName,
          where: 'taskId = ?', whereArgs: [id]);

      if (rows < 0) {
        return false;
      }
      return true;
    } catch (e) {
      log("daleteOneTaskItem Error : $e");
      return false;
    }
  }
// update task
   Future<bool> updateTask(String taskTitle, int id) async {
    try {
      Database? database = await getTaskDb();
      int rows = await database.update(
          TaskModel.tasktableName,
          {
            TaskModel.key_taskTitle: taskTitle,
          },
          where: '${TaskModel.key_taskId} = ?',
          whereArgs: [id]);
      log('*************************update data*******************');

      if (rows < 0) {
        return false;
      }
      return true;
    } catch (e) {
      log("update Error : $e");
      return false;
    }
  }
}