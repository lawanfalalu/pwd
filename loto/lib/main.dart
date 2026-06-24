import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';
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
  
  final String lang = "hs";

  late final Lokaci _createTime = Lokaci(lang);

  late String _displayText = lang == "hs"
    ? "Girgiza waya domin sauraron lokaci"
    : "Share your phone listen to the time";

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

    final words = sentence
      .trim()
      .split(RegExp(r'\s+'));

    final audioSources = words.map((word) {

      final cleanWord = word
          .toLowerCase()
          .replaceAll("'", "");

      return AudioSource.asset(
        'assets/audio/$lang/$cleanWord.mp3',
      );

    }).toList();

    await _player.setAudioSources(audioSources);

    await _player.play();
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

      /**
       onDoubleTap: _announceTime,
        child: FloatingActionButton(
          onPressed: _announceTime,
          tooltip: 'Play Time',
          child: const Icon(Icons.volume_up),
        ),
      
      
       */

      floatingActionButton: FloatingActionButton(
        onPressed: _announceTime,
        tooltip: 'Play Time',
        child: const Icon(Icons.volume_up),
      ),
    );
  }
}