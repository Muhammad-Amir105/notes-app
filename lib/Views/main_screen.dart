// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:note_app/SQLite/sqlite.dart';
import 'package:note_app/Views/Notes/notes.dart';
import 'package:note_app/Views/ToDo/todo_main_screen.dart';

import '../JsonModels/user.dart';
import 'Auth/user_profile.dart';

class MainScreen extends StatefulWidget {
  String userName;
   MainScreen({super.key,required this.userName});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late DatabaseHelper helper;
  int currentIndex = 0;
  List<String> name = [
    "Notes",
    "Tasks",
  ];

  @override
  void initState() {
    _pageController = PageController();
    helper = DatabaseHelper();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: currentIndex == 0 ? const Text("Notes") : const Text("Tasks"),
          actions: [
            InkWell(
              onTap: () async {
                Users? usrDetails =
                    await helper.getUser(widget.userName.toString());
                log("userDetails : $usrDetails");
                if (usrDetails != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Profile(
                              profile: usrDetails,
                            )),
                  );
                }
              },
              child: const Icon(
                Icons.person_pin,
                size: 35,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              SizedBox(
                height: 70,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: name.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                              _pageController.animateToPage(
                                currentIndex,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            margin: const EdgeInsets.only(
                                top: 6, left: 65, right: 8, bottom: 4),
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? Colors.white
                                    : Colors.grey.shade100,
                                border: currentIndex == index
                                    ? Border.all(color: Colors.blue, width: 3)
                                    : null,
                                borderRadius: currentIndex == index
                                    ? BorderRadius.circular(10)
                                    : BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                name[index],
                                style: TextStyle(
                                    color: currentIndex == index
                                        ? Colors.blue
                                        : Colors.black87,
                                    fontWeight: currentIndex == index
                                        ? FontWeight.bold
                                        : FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Visibility(
                              visible: currentIndex == index,
                              child: Container(
                                width: 60,
                                height: 4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue),
                              )),
                        )
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: PageView(
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    controller: _pageController,
                    children:  [
                      NotesScreen(username: widget.userName.toString() ,),
                      const ToDoMainScreen(),
                    ]),
              )
            ],
          ),
        ));
  }
}
