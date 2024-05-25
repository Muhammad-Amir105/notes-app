import 'dart:developer';
import 'speech_to_text.dart';
import 'package:intl/intl.dart';
import 'create_note_screen.dart';
import 'image_to_text_screen.dart';
import '../../JsonModels/user.dart';
import 'package:flutter/material.dart';
import '../../JsonModels/note_model.dart';
import 'package:note_app/SQLite/sqlite.dart';
import 'package:note_app/Views/Notes/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: use_build_context_synchronously

// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

class NotesScreen extends StatefulWidget {
  String username;
  NotesScreen({super.key, required this.username});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late DatabaseHelper helper;
  late Future<List<NoteModel>> notes;
  Users? user;
  late TextEditingController title;
  late TextEditingController content;
  late TextEditingController search;

  @override
  void initState() {
    super.initState();
    title = TextEditingController();
    content = TextEditingController();
    search = TextEditingController();
    helper = DatabaseHelper();
    notes = helper.fetchData();

    _fetchUserData().whenComplete(
      () {
        saveUser();
      },
    );
    helper.notesDB().whenComplete(() {
      notes = getAllNotes();
    });
  }

  Future<void> _fetchUserData() async {
    try {
      dynamic fetchedUser = await helper.getUser(widget.username);
      if (mounted) {
        setState(() {
          user = fetchedUser;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<bool> saveUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('user_id', user!.usrId.toString());
    sp.setString('user_email', user!.usrEmail.toString());
    return true;
  }

  Future<List<NoteModel>> getAllNotes() async {
    return await helper.fetchData();
  }

  Future<void> refresh() async {
    setState(() {
      notes = helper.fetchData();
    });
  }

  Future<List<NoteModel>> searchNote() {
    return helper.searchNotes(search.text);
  }

  @override
  Widget build(BuildContext context) {
    log("user:${widget.username.toString()}");
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
                    notes = searchNote();
                  });
                } else {
                  setState(() {
                    notes = getAllNotes();
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
            child: FutureBuilder<List<NoteModel>>(
                future: notes,
                builder: (context, AsyncSnapshot<List<NoteModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Notes Available"));
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    final items = snapshot.data ?? <NoteModel>[];
                    final userId = user?.usrId;

                    final filteredItems =
                        items.where((note) => note.noteId == userId).toList();

                    if (filteredItems.isEmpty) {
                      return const Center(
                          child: Text("No Notes Available for this user"));
                    }

                    return ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        log("notes Id:${filteredItems[index].noteId}");
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            shadowColor: const Color(0xff734a34),
                            elevation: 3,
                            child: ListTile(
                              leading: const Icon(
                                Icons.note,
                                size: 30,
                              ),
                              title: Text(
                                filteredItems[index].noteTitle.toString(),
                              ),
                              subtitle: Text(DateFormat("yMd").format(
                                  DateTime.parse(
                                      filteredItems[index].createdAt))),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailSCreen(
                                        title: filteredItems[index].noteTitle,
                                        content:
                                            filteredItems[index].noteContent,
                                        contentId: filteredItems[index].noteId!,
                                        userName: widget.username,
                                      ),
                                    )).whenComplete(() {
                                  setState(() {
                                    refresh();
                                  });
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
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Center(
                child: Material(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: AlertDialog(
                      title: const Center(
                        child: Text(
                          'Notes',
                        ),
                      ),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            elevation: 5,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            colorBrightness: Brightness.dark,
                            splashColor: Colors.white12,
                            animationDuration:
                                const Duration(milliseconds: 500),
                            textColor: Colors.white,
                            color: const Color(0xff734a34),
                            child: const FittedBox(
                                fit: BoxFit.contain,
                                child: Text('Add Notes With Text')),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateNote(
                                            id: user!.usrId,
                                          ))).then((value) {
                                if (value) {
                                  refresh();
                                  Navigator.of(context).pop();
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            elevation: 5,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            colorBrightness: Brightness.dark,
                            splashColor: Colors.white12,
                            animationDuration:
                                const Duration(milliseconds: 500),
                            textColor: Colors.white,
                            color: const Color(0xff734a34),
                            child: const FittedBox(
                                fit: BoxFit.contain,
                                child: Text('Add Notes With Voice')),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SpeechToTextScreen(
                                            id: user!.usrId,
                                          ))).then((value) {
                                if (value) {
                                  refresh();
                                  Navigator.of(context).pop();
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            elevation: 5,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            colorBrightness: Brightness.dark,
                            splashColor: Colors.white12,
                            animationDuration:
                                const Duration(milliseconds: 500),
                            textColor: Colors.white,
                            color: const Color(0xff734a34),
                            child: const FittedBox(
                                fit: BoxFit.contain,
                                child: Text('Add Notes With Image To Text')),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ImageToTextNotesScreen(
                                            id: user!.usrId,
                                          ))).then((value) {
                                if (value) {
                                  refresh();
                                  Navigator.of(context).pop();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
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
