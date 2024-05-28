import 'dart:developer';
import 'package:flutter/material.dart';
import '../../JsonModels/task_model.dart';
import '../../widgets/custom_button.dart';
import 'package:animate_do/animate_do.dart';
import 'package:note_app/Views/main_screen.dart';
import 'package:note_app/SQLite/task_sqlite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';

// ignore_for_file: non_constant_identifier_names

// ignore_for_file: must_be_immutable

// ignore_for_file: use_build_context_synchronously

// ignore_for_file: unused_local_variable

// ignore_for_file: library_private_types_in_public_api
class AddTaskScreen extends StatefulWidget {
  String userName;
  AddTaskScreen({super.key, required this.userName});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController addTask;
  late DataBaseHelperTasks helper;
  String? user_id;

  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    addTask = TextEditingController();
    helper = DataBaseHelperTasks();
    loadUser();
  }

  Future<void> loadUser() async {
    user_id = await getUser();
  }

  Future<String?> getUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("user_id");
  }

  @override
  void dispose() {
    addTask.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("userid in todo:$user_id");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        leading: InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MainScreen(userName: widget.userName.toString()),
                ),
                (route) => false,
              );
            },
            child: const Icon(Icons.arrow_back)),
      ),
      body: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 30, bottom: 15),
              child: FadeInUp(
                duration: const Duration(milliseconds: 1500),
                child: TextFormField(
                  cursorColor: const Color(0xff734a34),
                  controller: addTask,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Content is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.add_task,
                        color: Colors.grey,
                      ),
                      labelText: 'Enter Task Name',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 2, color: Color(0xff734a34)),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xff734a34))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xff734a34))),
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
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => const ReminderBottomSheet());
                },
                child: Container(
                  height: 30,
                  width: 120,
                  margin: const EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Spacer(),
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.alarm_add,
                          size: 20,
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 6,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Set reminder",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 1200),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: CustomButton(
                      title: "Save Task",
                      onTap: () async {
                        int id = int.parse(user_id.toString());

                        if (key.currentState != null &&
                            key.currentState!.validate()) {
                          String title = addTask.text;
                          addTask.clear();

                          await helper.createtask(
                            TaskModel(
                              taskId: id,
                              taskTitle: title,
                              createdAt: DateTime.now().toIso8601String(),
                            ),
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreen(
                                  userName: widget.userName.toString()),
                            ),
                            (route) => false,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Task Add Successfully!")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Form key or validation failed")));
                        }
                      }),
                ))
          ],
        ),
      ),
    );
  }
}

class ReminderBottomSheet extends StatefulWidget {
  const ReminderBottomSheet({super.key});

  @override
  _ReminderBottomSheetState createState() => _ReminderBottomSheetState();
}

class _ReminderBottomSheetState extends State<ReminderBottomSheet> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool correct = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(4000),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _setReminder() {
    if (selectedDate != null && selectedTime != null) {
      final DateTime reminderDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      FlutterAlarmClock.createAlarm(
          hour: selectedTime!.hour, minutes: selectedTime!.minute);
      Navigator.of(context).pop();
    } else {
      setState(() {
        correct = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select both date and time"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(selectedDate == null
                ? 'Select date'
                : "Selected date: ${selectedDate!.toLocal()}".split(' ')[2]),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          ListTile(
            title: Text(selectedTime == null
                ? 'Select Time'
                : selectedTime!.format(context)),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectTime(context),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(onPressed: _setReminder, child: const Text("Done"))
            ],
          ),
          correct == true
              ? const Text("Please select both Date and Time")
              : const SizedBox(),
        ],
      ),
    );
  }
}
