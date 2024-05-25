// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/widgets/custom_button.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../JsonModels/note_model.dart';
import '../../SQLite/sqlite.dart';

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({super.key});

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  late SpeechToText _speechToText;
  late DatabaseHelper helper;

  bool _speechEnabled = false;
  String _wordsSpoken = "";

  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    _speechToText = SpeechToText();
    helper = DatabaseHelper();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Speech To Text',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
         actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CupertinoButton(
                minSize: 0,
                padding: EdgeInsets.zero,
                child: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _wordsSpoken));
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to Clipboard')));
                }),
          )
        ],
         leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: const Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "listening..."
                    : _speechEnabled
                        ? "Tap the microphone to start listening..."
                        : "Speech not available",
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Container(
              height: 400,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff734a34), width: 3)),
              child: Text(
                _wordsSpoken,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: CustomButton(
                  title: "Save Notes",
                  onTap: () async {
                    if (_wordsSpoken != "") {
                      List<String> words = _wordsSpoken.split(' ');
                      String title =
                          words.isNotEmpty ? words[0].toUpperCase() : " ";
                      String content = _wordsSpoken;

                      helper
                          .createNote(NoteModel(
                              noteTitle: title,
                              noteContent: content,
                              createdAt: DateTime.now().toIso8601String()))
                          .whenComplete(() {
                        Navigator.of(context).pop(true);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Note Add Successfully!")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please first speech than save")));
                    }
                  }),
            )
            // if (_speechToText.isNotListening && _confidenceLevel > 0)
            //   Padding(
            //     padding: const EdgeInsets.only(
            //       bottom: 100,
            //     ),
            //     child: Text(
            //       "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
            //       style: const TextStyle(
            //         fontSize: 30,
            //         fontWeight: FontWeight.w200,
            //       ),
            //     ),
            //   )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        backgroundColor: const Color(0xff734a34),
        child: Icon(
          _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
