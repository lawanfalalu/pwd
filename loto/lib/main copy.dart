import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shake/shake.dart';

import 'time_in_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hausa Talking Clock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
      ),
      home: const MyHomePage(title: 'Loto'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final AudioPlayer _player = AudioPlayer();

  final Lokaci _createTime = Lokaci("hs");

  String _displayText =
      "Girgiza waya domin sauraron lokaci";

  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    ShakeDetector.autoStart(
      onPhoneShake: (ShakeEvent event) {
        _announceTime();
      },
    );
  }


  Future<void> _announceTime() async {

    if (_isPlaying) return;

    _isPlaying = true;

    try {

      String sentence = _createTime.getPWDTime();

      setState(() {
        _displayText = sentence.replaceAll("_", " ");
      });

      await _speakSentence(sentence);

    } finally {

      _isPlaying = false;
    }
  }

  Future<void> _speakSentence(String sentence) async {

    List<String> words = sentence
        .trim()
        .split(RegExp(r'\s+'));

    for (String word in words) {

      String cleanWord = word
          .toLowerCase();
          // .replaceAll(",", "")
          // .replaceAll(".", "")
          // .replaceAll("'", "");

      try {

        await _player.play(
          AssetSource('audio/hs/$cleanWord.mp3'),
        );
       await _player.onPlayerComplete.first;

      } catch (e) {

        debugPrint(
          "Missing audio: $cleanWord.mp3",
        );
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Text(
            _displayText,

            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _announceTime,
        tooltip: 'Play Time',
        child: const Icon(Icons.volume_up),
      ),
    );
  }
}