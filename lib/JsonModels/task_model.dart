// ignore_for_file: constant_identifier_names

class TaskModel {
  final int? taskId;
  final String taskTitle;
  final String createdAt;

  static const String tasktableName = "tasks_tb";
  static const String key_taskId = 'taskId';
  static const String key_taskTitle = 'taskTitle';
  static const String key_createAt = 'createdAt';

  static const String taskTableCreate =
      "CREATE TABLE $tasktableName($key_taskId INTEGER PRIMARY KEY AUTOINCREMENT, $key_taskTitle TEXT, $key_createAt TEXT DEFAULT CURRENT_TIMESTAMP)";
  static const String dropTabletask = 'DROP TABLE IF EXISTS $tasktableName';
  static const String fetch_task = 'SELECT * FROM $tasktableName';

  TaskModel({
    this.taskId,
    required this.taskTitle,
    required this.createdAt,
  });

  factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
        taskId: json["taskId"],
        taskTitle: json["taskTitle"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toMap(TaskModel taskModel) {
    return {
      TaskModel.key_taskId: taskModel.taskId,
      TaskModel.key_taskTitle: taskModel.taskTitle,
      TaskModel.key_createAt: taskModel.createdAt,
    };
  }
}
