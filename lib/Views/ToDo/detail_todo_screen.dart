import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../../SQLite/task_sqlite.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

// ignore_for_file: deprecated_member_use, use_build_context_synchronously

class ToDoUpdateScreen extends StatefulWidget {
  int taskId;
  String taskName;
  ToDoUpdateScreen({
    super.key,
    required this.taskId,
    required this.taskName,
  });

  @override
  State<ToDoUpdateScreen> createState() => _ToDoUpdateScreenState();
}

class _ToDoUpdateScreenState extends State<ToDoUpdateScreen> {
  late TextEditingController taskNameController;
  late DataBaseHelperTasks helper;

  @override
  void initState() {
    super.initState();
    helper = DataBaseHelperTasks();
    taskNameController = TextEditingController();
    taskNameController.text = widget.taskName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Update Task'),
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 1500),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: TextField(
                controller: taskNameController,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.update,
                      color: Colors.black,
                    ),
                    labelText: 'Enter Task Name',
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 2, color: Color(0xff734a34)),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 2, color: Color(0xff734a34)))),
              ),
            ),
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 1000),
            delay: const Duration(milliseconds: 1000),
            child: SizedBox(
              width: 200,
              height: 45,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xff734a34),
                  ),
                  onPressed: () async {
                    String task1 = taskNameController.text.toString();

                    log("title:$task1 ,taskId:${widget.taskId}");
                    helper.updateTask(task1, widget.taskId).whenComplete(() {
                      taskNameController.clear();
                      Navigator.of(context).pop(true);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Task Update Successfully!")));
                    });
                  },
                  child: const Text(
                    'Update Task',
                    style: TextStyle(fontSize: 20),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
