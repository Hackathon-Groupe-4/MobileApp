import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechBottomSheet extends StatefulWidget {
  final SpeechToText speechToText;

  SpeechBottomSheet({required this.speechToText, Key? key}) : super(key: key);

  final _SpeechBottomSheetState _state = _SpeechBottomSheetState();

  void updateText(String text) {
    _state.updateText(text);
  }

  @override
  _SpeechBottomSheetState createState() => _state;
}

class _SpeechBottomSheetState extends State<SpeechBottomSheet> {
  String _lastWords = "";

  void updateText(String text) {
    setState(() {
      _lastWords = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _lastWords,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              widget.speechToText.stop();
              Navigator.pop(context);
            },
            child: Text("Fermer"),
          ),
        ],
      ),
    );
  }
}
