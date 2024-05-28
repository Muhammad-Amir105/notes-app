import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../SQLite/task_sqlite.dart';
import 'package:note_app/JsonModels/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_app/Views/ToDo/detail_todo_screen.dart';
import 'package:note_app/Views/ToDo/add_todo_task_screen.dart';

// ignore_for_file: use_build_context_synchronously

// ignore_for_file: non_constant_identifier_names, must_be_immutable

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: deprecated_member_use, prefer_null_aware_operators

class ToDoMainScreen extends StatefulWidget {
  String userName;
  ToDoMainScreen({super.key, required this.userName});

  @override
  State<ToDoMainScreen> createState() => _ToDoMainScreenState();
}

class _ToDoMainScreenState extends State<ToDoMainScreen> {
  late DataBaseHelperTasks helper;
  late Future<List<TaskModel>> task;
  String? user_id;
  late TextEditingController search;

  @override
  void initState() {
    super.initState();

    search = TextEditingController();
    helper = DataBaseHelperTasks();
    task = helper.fetchTaskData();
    loadUser();
    helper.getTaskDb().whenComplete(() {
      task = getAllTasks();
    });
  }

  Future<List<TaskModel>> getAllTasks() async {
    return await helper.fetchTaskData();
  }

  Future<void> refresh() async {
    setState(() {
      task = getAllTasks();
    });
  }

  Future<List<TaskModel>> searchTask() {
    return helper.searchtasks(search.text);
  }

  Future<void> loadUser() async {
    user_id = await getUser();
  }

  Future<String?> getUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("user_id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: const Color(0xff734a34).withOpacity(.2),
                borderRadius: BorderRadius.circular(8)),
            child: TextFormField(
              controller: search,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    task = searchTask();
                  });
                } else {
                  setState(() {
                    task = getAllTasks();
                  });
                }
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: "Search"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<TaskModel>>(
                future: task,
                builder: (context, AsyncSnapshot<List<TaskModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Tasks Avaible"));
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    final items = snapshot.data ?? <TaskModel>[];
                    int? userId = int.parse(user_id.toString());
                    final filteredItems =
                        items.where((task) => task.taskId == userId).toList();

                    if (filteredItems.isEmpty) {
                      return const Center(
                          child: Text("No tasks Available for this user"));
                    }
                    return ListView.builder(
                      itemCount: filteredItems.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        log("task Id:${filteredItems[index].taskId}");
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            shadowColor: const Color(0xff734a34),
                            elevation: 3,
                            child: ListTile(
                              leading: const Icon(
                                Icons.task,
                                size: 30,
                              ),
                              title: Text(
                                filteredItems[index].taskTitle.toString(),
                              ),
                              subtitle: Text(DateFormat("yMd").format(
                                  DateTime.parse(
                                      filteredItems[index].createdAt))),
                              trailing: IconButton(
                                  onPressed: () {
                                    // show dialog for task delete
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Center(
                                            child: Text(
                                              'Tasks',
                                            ),
                                          ),
                                          content: const Text(
                                              'Are you sure you want to delete this task?'),
                                          actions: <Widget>[
                                            MaterialButton(
                                              minWidth: 20,
                                              elevation: 5,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              colorBrightness: Brightness.dark,
                                              splashColor: Colors.white12,
                                              animationDuration: const Duration(
                                                  milliseconds: 500),
                                              textColor: Colors.white,
                                              color: const Color(0xff734a34),
                                              child: const Text('No'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            MaterialButton(
                                              minWidth: 20,
                                              elevation: 5,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              colorBrightness: Brightness.dark,
                                              splashColor: Colors.white12,
                                              animationDuration: const Duration(
                                                  milliseconds: 500),
                                              textColor: Colors.white,
                                              color: const Color(0xff734a34),
                                              child: const Text('Yes'),
                                              onPressed: () async {
                                                helper
                                                    .daleteOneTaskItem(
                                                        filteredItems[index]
                                                            .taskId!)
                                                    .whenComplete(() {
                                                  refresh();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Task Delete Successfully!")));
                                                });

                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ToDoUpdateScreen(
                                        taskName: items[index].taskTitle,
                                        taskId: items[index].taskId!,
                                      ),
                                    )).then((value) {
                                  if (value) {
                                    refresh();
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff734a34),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTaskScreen(
                        userName: widget.userName.toString(),
                      ))).then((value) {
            if (value) {
              refresh();
            }
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}
