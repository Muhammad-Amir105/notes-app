import '../../Custom/constant.dart';
import 'package:flutter/material.dart';
import '../../JsonModels/note_model.dart';
import 'package:note_app/SQLite/sqlite.dart';
import 'package:note_app/widgets/custom_button.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  late TextEditingController title;
  late TextEditingController content;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late DatabaseHelper helper;


  @override
  void initState() {
    title = TextEditingController();
    content = TextEditingController();
    helper = DatabaseHelper();
    super.initState();
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
        title: const Text("Create note"),
       leading: InkWell(
        onTap: () {
          Navigator.of(context).pop(true);
        },
        child: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    cursorColor: const Color(0xff734a34),
                    controller: title,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Title is required";
                      }
                      return null;
                    },
                    style: const TextStyle(color: kGreyColor),
                    decoration: InputDecoration(
                        hintText: " Enter note title",
                        labelText: "Title",
                        // hintStyle: const TextStyle(color: kGreyColor),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 23.0, vertical: 15),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: kPrimaryColor)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.red)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: kPrimaryColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: kPrimaryColor, width: 2))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    cursorColor: const Color(0xff734a34),
                    controller: content,
                    textInputAction: TextInputAction.done,
                    maxLines: 15,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Content is required";
                      }
                      return null;
                    },
                    style: const TextStyle(color: kGreyColor),
                    decoration: InputDecoration(
                        hintText: "Enter note content",
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 23.0, vertical: 15),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: kPrimaryColor)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.red)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: kPrimaryColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: kPrimaryColor, width: 2))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      title: "Save Note",
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          String title1 = title.text;
                          String content1 = content.text;
                          title.clear();
                          content.clear();
                          helper
                              .createNote(NoteModel(
                                  noteTitle: title1,
                                  noteContent: content1,
                                  createdAt: DateTime.now().toIso8601String()))
                              .whenComplete(() {
                            Navigator.of(context).pop(true);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Note Add Successfully!")));
                        }
                      })
                ],
              ),
            )),
      ),
    );
  }
}
