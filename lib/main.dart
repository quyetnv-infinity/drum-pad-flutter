import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import 'note.util.dart';

void main() {
  runApp(const DrumpadApp());
}

class DrumpadApp extends StatelessWidget {
  const DrumpadApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drumpad',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DrumpadScreen(),
    );
  }
}

class DrumpadScreen extends StatefulWidget {
  const DrumpadScreen({Key? key}) : super(key: key);

  @override
  State<DrumpadScreen> createState() => _DrumpadScreenState();
}

class _DrumpadScreenState extends State<DrumpadScreen> {
  List<String> availableSounds = [];
  Map<String, AudioPlayer> audioPlayers = {};
  List<Map<String, dynamic>> events = [];
  int currentEventIndex = 0;
  Timer? sequenceTimer;
  bool isPlaying = false;
  Set<String> highlightedSounds = {};
  bool notePressed = false;
  double startTimeOffset = 0;
  DateTime? startTime;
  bool isLoading = true;

  List<dynamic> lessons = [];
  int currentLesson = 0;

  final Map<String, Color> soundColors = {
    'lead': Colors.red,
    'bass': Colors.green,
    'drums': Colors.blue,
    'fx': Colors.yellow,
  };

  @override
  void initState() {
    super.initState();
    _loadSequenceDataFromFile().then((_) {
      _initializeAudioPlayers();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _disposeAudioPlayers();
    sequenceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSequenceDataFromFile() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/sequence.json');
      final jsonData = json.decode(jsonString);
      lessons = List.from(jsonData);
      currentLesson = lessons.length - 1;
      events = List<Map<String, dynamic>>.from(lessons[currentLesson]['events']);
      final Set<String> uniqueSounds = {};
      for (var event in events) {
        final notes = List<String>.from(event['notes']);
        uniqueSounds.addAll(notes);
      }
      availableSounds.addAll(sortDrumpadSounds(uniqueSounds.toList()));
    } catch (e) {
      print('Error loading sequence data from file: $e');
      events = [];
      availableSounds.clear();
    }
  }

  Future<void> _initializeAudioPlayers() async {
    _disposeAudioPlayers();
    for (String sound in availableSounds) {
      if (sound.isEmpty) return;
      final player = AudioPlayer();
      try {
        await player.setAsset('assets/audio/$sound.mp3');
        audioPlayers[sound] = player;
      } catch (e) {
        print('Error loading audio file for $sound: $e');
      }
    }
  }

  void _disposeAudioPlayers() {
    for (var player in audioPlayers.values) {
      player.dispose();
    }
    audioPlayers.clear();
    setState(() {
      audioPlayers = {};
    });
  }

  void _playSound(String sound) {
    if (audioPlayers.containsKey(sound)) {
      audioPlayers[sound]?.seek(Duration.zero);
      audioPlayers[sound]?.play();
    }
  }

  void _startSequence() {
    if (isPlaying || events.isEmpty) return;
    setState(() {
      isPlaying = true;
      currentEventIndex = 0;
      startTimeOffset = 0;
      startTime = DateTime.now();
      highlightedSounds.clear();
      notePressed = false;
    });
    _scheduleNextEvent();
  }

  void _resetSequence() {
    setState(() {
      isPlaying = false;
      currentEventIndex = 0;
      startTimeOffset = 0;
      highlightedSounds.clear();
      notePressed = false;
    });
  }

  void _scheduleNextEvent() {
    sequenceTimer?.cancel();
    if (currentEventIndex >= events.length) {
      _resetSequence();
      return;
    }
    final currentEvent = events[currentEventIndex];
    final nextEventTime = currentEvent['time'] as double;
    if (currentEventIndex == 0) {
      startTimeOffset = 0.0;
    } else {
      final prevEvent = events[currentEventIndex - 1];
      startTimeOffset = prevEvent['time'] as double;
    }
    final timeUntilEvent = nextEventTime - startTimeOffset;
    sequenceTimer = Timer(Duration(milliseconds: (timeUntilEvent * 1000).round()), () {
      _processEvent(currentEvent);
    });
  }

  void _processEvent(Map<String, dynamic> event) {
    final notes = List<String>.from(event['notes']);
    setState(() {
      highlightedSounds.clear();
      highlightedSounds.addAll(notes);
    });
    for (var note in notes) {
      // print(note);
      _playSound(note);
    }
    currentEventIndex++;
    _scheduleNextEvent();
  }

  Color _getPadColor(String sound) {
    for (var key in soundColors.keys) {
      if (sound.contains(key)) {
        return soundColors[key]!;
      }
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drumpad'),
        actions: [
          IconButton(onPressed: _startSequence, icon: Icon(Icons.play_arrow))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final bool hasSound = index < availableSounds.length;
                  final String soundId = hasSound ? availableSounds[index] : '';
                  final bool isHighlighted = highlightedSounds.contains(soundId);
                  return GestureDetector(
                    onTap: () {
                      _playSound(availableSounds[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isHighlighted ? Colors.orange : (hasSound ? _getPadColor(soundId) : Colors.grey),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      // child: Center(
                      //   child: Text(
                      //     hasSound ? soundId : 'Empty',
                      //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                    ),
                  );
                },
              ),
            ),
            Wrap(
              children: List.generate(lessons.length, (index) => TextButton(onPressed: () async {
                setState(() {
                  isLoading = true;
                  currentLesson = index;
                  events = List<Map<String, dynamic>>.from(lessons[currentLesson]['events']);
                  final Set<String> uniqueSounds = {};
                  for (var event in events) {
                    final notes = List<String>.from(event['notes']);
                    uniqueSounds.addAll(notes);
                  }
                  availableSounds.clear();
                  availableSounds.addAll(sortDrumpadSounds(uniqueSounds.toList()));
                });
                await _initializeAudioPlayers();
                setState(() {
                  isLoading = false;
                });
                // Future.delayed(Duration(microseconds: 1000), _startSequence);
              }, child: Text(index.toString(), style: TextStyle(color: index == currentLesson ? Colors.blue : Colors.black)))),
            )
          ],
        ),
      ),
    );
  }
}