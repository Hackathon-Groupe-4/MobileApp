import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechBottomSheet extends StatefulWidget {
  final void Function(String Sense) onCommandDetected; // Callback

  SpeechBottomSheet({Key? key, required this.onCommandDetected}) : super(key: key);

  static final GlobalKey<_SpeechBottomSheetState> keyState = GlobalKey<_SpeechBottomSheetState>();

  static bool isNotListening() {
    return keyState.currentState?._speechToText.isNotListening ?? true;
  }

  @override
  _SpeechBottomSheetState createState() => _SpeechBottomSheetState();
}

class _SpeechBottomSheetState extends State<SpeechBottomSheet> {
  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = "";
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    _startListening();
  }

  void _startListening() async {
    if (!_isListening) {
      setState(() {
        _isListening = true;
      });
      await _speechToText.listen(onResult: _onSpeechResult);
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    if (_speechToText.isNotListening) {
      setState(() {
        _isListening = false;
      });

      // Analyse de la phrase pour détecter les commandes
      _processSpeechCommand(_lastWords);
    }
  }

  void _processSpeechCommand(String sentence) {
    widget.onCommandDetected(sentence);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _lastWords,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _isListening ? _stopListening : _startListening,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isListening ? Colors.red : Colors.blue,
            ),
            child: Text(
              _isListening ? "Annuler" : "Écouter",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
