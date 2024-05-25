import 'dart:developer';
import '../../SQLite/sqlite.dart';
import '../../Custom/constant.dart';
import 'package:flutter/material.dart';
import '../../JsonModels/note_model.dart';
import '../../widgets/custom_button.dart';
import 'package:note_app/Views/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first, use_super_parameters, must_be_immutable

class DetailSCreen extends StatefulWidget {
  String title;
  int contentId;
  String content;
  String userName;

  DetailSCreen(
      {Key? key,
      required this.title,
      required this.contentId,
      required this.content,
      required this.userName})
      : super(key: key);

  @override
  State<DetailSCreen> createState() => _DetailSState();
}

class _DetailSState extends State<DetailSCreen> {
  late DatabaseHelper helper;
  late TextEditingController title;
  late TextEditingController content;
  late Future<List<NoteModel>> notes;

  Future<List<NoteModel>> getAllNotes() async {
    return await helper.fetchData();
  }

  Future<bool> remove() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('user_id');
    return true;
  }

  Future<void> refresh() async {
    setState(() {
      notes = helper.fetchData();
    });
  }

  @override
  void initState() {
    super.initState();
    title = TextEditingController();
    content = TextEditingController();
    title.text = widget.title;
    content.text = widget.content;
    helper = DatabaseHelper();
    notes = helper.fetchData();

    helper.notesDB().whenComplete(() {
      notes = getAllNotes();
    });
  }

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back)),
        title: Text(widget.title.toString()),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                cursorColor: const Color(0xff734a34),
                controller: title,
                textInputAction: TextInputAction.next,
                style: const TextStyle(color: kTertiaryColor),
                decoration: InputDecoration(
                    labelText: "Title",
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 23.0, vertical: 15),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: kPrimaryColor)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: kPrimaryColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: kPrimaryColor, width: 2))),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                cursorColor: const Color(0xff734a34),
                controller: content,
                textInputAction: TextInputAction.done,
                maxLines: 15,
                style: const TextStyle(color: kTertiaryColor),
                decoration: InputDecoration(
                    labelText: "Content",
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 23.0, vertical: 15),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: kPrimaryColor)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: kPrimaryColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: kPrimaryColor, width: 2))),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                        title: "Update Note",
                        onTap: () {
                          String title1 = title.text.toString();
                          String content1 = content.text.toString();
                          log("title:$title1 , Content:$content1 , noteId:${widget.contentId}");
                          helper
                              .updateNote(title1, content1, widget.contentId)
                              .whenComplete(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MainScreen(userName: widget.userName),
                                ));
                            title.clear();
                            content.clear();
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Note Update Successfully!")));

                          // Navigator.of(context).pop();
                        }),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: CustomButton(
                        title: "Delete Note",
                        onTap: () {
                          // show dialog for note delete
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Center(
                                  child: Text(
                                    'Notes',
                                  ),
                                ),
                                content: const Text(
                                    'Are you sure you want to delete this notes?'),
                                actions: <Widget>[
                                  MaterialButton(
                                    minWidth: 20,
                                    elevation: 5,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    colorBrightness: Brightness.dark,
                                    splashColor: Colors.white12,
                                    animationDuration:
                                        const Duration(milliseconds: 500),
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
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    colorBrightness: Brightness.dark,
                                    splashColor: Colors.white12,
                                    animationDuration:
                                        const Duration(milliseconds: 500),
                                    textColor: Colors.white,
                                    color: const Color(0xff734a34),
                                    child: const Text('Yes'),
                                    onPressed: () async {
                                      helper
                                          .daleteOneDataItem(widget.contentId)
                                          .whenComplete(() {
                                        refresh();
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Note Delete Successfully!")));
                                      });
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Go Back",
                    style: TextStyle(
                        color: Color(0xff734a34),
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
