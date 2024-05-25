import 'dart:developer';

import 'package:intl/intl.dart';
import 'create_note_screen.dart';
import 'package:flutter/material.dart';
import '../../JsonModels/note_model.dart';
import 'package:note_app/SQLite/sqlite.dart';
import 'package:note_app/Views/Notes/detail_screen.dart';

import 'image_to_text_screen.dart';
import 'speech_to_text.dart';

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
  dynamic  getuser=helper.getUser(widget.username);
    helper.notesDB().whenComplete(() {
      notes = getAllNotes();
    
    });

    log("getUser: $getuser"); 

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
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Notes Avaible"));
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    final items = snapshot.data ?? <NoteModel>[];
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
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
                                items[index].noteTitle.toString(),
                              ),
                              subtitle: Text(DateFormat("yMd").format(
                                  DateTime.parse(items[index].createdAt))),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailSCreen(
                                        title: items[index].noteTitle,
                                        content: items[index].noteContent,
                                        contentId: items[index].noteId!,
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
                    height: MediaQuery.of(context).size.height * 0.4,
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
                                      builder: (context) =>
                                          const CreateNote())).then((value) {
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
                                          builder: (context) =>
                                              const SpeechToTextScreen()))
                                  .then((value) {
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
                                              const ImageToTextNotesScreen()))
                                  .then((value) {
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
