import 'dart:async';
import 'dart:convert';
import 'package:drumpad_flutter/sound_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
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
  List<String> lessonSounds = [];
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
  double progressValue = 0.0;
  Timer? progressTimer;
  Map<String, double> padProgress = {};

  int? _currentHoverIndex;
  final GlobalKey _widgetPadKey = GlobalKey();
  String? _currentLeadSound;

  DateTime? lastEventTime;
  Map<String, String> padStates = {};
  List<dynamic> lessons = [];
  int currentLesson = 0;

  List<String> _faceA = [];
  List<String> _faceB = [];

  final Map<String, Color> soundColors = {
    'lead': Colors.red,
    'bass': Colors.green,
    'drums': Colors.blue,
    'fx': Colors.yellow,
  };

  final Map<String, SoundType> soundTypes = {
    'lead': SoundType.lead,
    'bass': SoundType.bass,
    'drums': SoundType.drum,
    'fx': SoundType.fx,
  };

  SoundType _getSoundType(String sound) {
    for (var key in soundTypes.keys) {
      if (sound.contains(key)) {
        return soundTypes[key]!;
      }
    }
    return SoundType.drum;
  }

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
    progressTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSequenceDataFromFile() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/sequence.json');
      final jsonData = json.decode(jsonString);
      lessons = List.from(jsonData);
      currentLesson = 8;
      events = List<Map<String, dynamic>>.from(lessons[currentLesson]['events']);
      Set<String> uniqueSounds = {};
      for (var lesson in lessons) {
        for (var event in lesson["events"]) {
          final notes = List<String>.from(event['notes']);
          uniqueSounds.addAll(notes);
        }
      }
      availableSounds.addAll(uniqueSounds.toList());
      uniqueSounds = {};
      for (var event in events) {
        final notes = List<String>.from(event['notes']);
        uniqueSounds.addAll(notes);
      }
      _splitSoundsByFace();
      lessonSounds.addAll(sortDrumpadSounds(uniqueSounds.toList(), lessons[currentLesson]['events'][0]["notes"][0].contains("_face_b_") ? _faceB : _faceA));
    } catch (e) {
      print('Error loading sequence data from file: $e');
      events = [];
      availableSounds.clear();
      lessonSounds.clear();
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

  void _splitSoundsByFace() {
    List<String> faceA = [];
    List<String> faceB = [];

    for (var sound in availableSounds) {
      if (sound.contains("_face_a_")) {
        faceA.add(sound);
      } else if (sound.contains("_face_b_")) {
        faceB.add(sound);
      }
    }
    setState(() {
      _faceA = faceA;
      _faceB = faceB;
    });
  }

  void _disposeAudioPlayers() {
    for (var player in audioPlayers.values) {
      player.pause();
      player.dispose();
    }
    audioPlayers.clear();
    setState(() {
      audioPlayers = {};
    });
  }

  void _playSound(String sound) {
    print(sound);
    if (audioPlayers.containsKey(sound)) {
      if(_getSoundType(sound) == SoundType.lead){
        if(_currentLeadSound != null) audioPlayers[_currentLeadSound]?.pause();
        setState(() {
          _currentLeadSound = sound;
        });
      }
      audioPlayers[sound]?.seek(Duration.zero);
      audioPlayers[sound]?.play();
    }
  }

  void _startSequence() {
    if (isPlaying || events.isEmpty) return;
    _resetSequence();
    setState(() {
      isPlaying = true;
    });
    _scheduleNextEvent();
  }

  void _resetSequence() {
    for (var player in audioPlayers.values) {
      player.pause();
    }
    setState(() {
      isPlaying = false;
      currentEventIndex = 0;
      startTimeOffset = 0;
      highlightedSounds.clear();
      notePressed = false;
      progressValue = 0.0;
      progressTimer = null;
      padProgress = {};
    });
    sequenceTimer?.cancel();
    progressTimer?.cancel();
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
    setState(() {
      highlightedSounds.clear();
      highlightedSounds.addAll(List<String>.from(event['notes']));
      progressValue = 0.0;
      padProgress.clear();
    });
    lastEventTime = DateTime.now();
    if (currentEventIndex > events.length - 1) return;

    double currentTime = event['time'];
    double prevTime = events[currentEventIndex == 0 ? 0 : currentEventIndex - 1]['time'];
    double delay = currentTime - prevTime;

    // Nếu nốt đầu tiên có thời gian là 0, thì bỏ qua progress cho nốt này
    if (currentEventIndex == 0 && currentTime == 0) return;

    for (var note in event['notes']) {
      padProgress[note] = 0.0;
    }

    progressTimer?.cancel();
    progressTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        for (var note in padProgress.keys) {
          padProgress[note] = (padProgress[note]! + (10 / (delay * 1000))).clamp(0.0, 1.0);
        }
        if (padProgress.values.every((value) => value == 1.0)) {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _onPadPressed(String sound, int index) async {
    await Haptics.vibrate(HapticsType.heavy);
    if (_currentHoverIndex == index) return;
    _playSound(sound);

    lastEventTime ??= DateTime.now();

    double currentTime = (DateTime.now().difference(lastEventTime!).inMilliseconds) / 1000.0;
    double requiredTime = events[currentEventIndex]['time'] - (currentEventIndex > 0 ? events[currentEventIndex - 1]['time'] : 0);

    String state = "";
    if(currentEventIndex != 0){
      if (currentTime < requiredTime - 0.5) {
        state = 'Early';
      } else if (currentTime < requiredTime - 0.2) {
        state = 'Gud';
      } else if (currentTime > requiredTime + 0.2) {
        state = 'Late';
      } else {
        state = 'Perfect';
      }
    }

    setState(() {
      padStates[sound] = state;
    });

    // Ẩn sau 2 giây
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        padStates.remove(sound);
      });
    });

    List<String> requiredNotes = List<String>.from(events[currentEventIndex]['notes']);
    if(!requiredNotes.contains(sound) && currentEventIndex != 0){
      setState(() {
        padStates[sound] = 'Miss';
      });
    }

    if (highlightedSounds.contains(sound)) {
      for (var remainingSound in highlightedSounds) {
        if (remainingSound != sound) {
          _playSound(remainingSound);
        }
      }
      // Nếu tất cả các nốt của sự kiện hiện tại đã được phát, chuyển sang sự kiện tiếp theo
      currentEventIndex++;
      if (currentEventIndex < events.length) {
        _processEvent(events[currentEventIndex]);
      } else {
        _resetSequence(); // Kết thúc nếu không còn sự kiện nào
      }
    }
  }

  Color _getPadColor(String sound) {
    for (var key in soundColors.keys) {
      if (sound.contains(key)) {
        return soundColors[key]!;
      }
    }
    return Colors.grey;
  }

  double _getPositionTop() {
    final RenderBox renderBox = _widgetPadKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero); // Lấy vị trí tuyệt đối
    final double top = position.dy;
    final double bottom = top + renderBox.size.height;
    return top;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerMove: (event) async {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset localPosition = box.globalToLocal(event.position);

        double itemWidth = box.size.width / 3;
        double itemHeight = itemWidth;
        int col = (localPosition.dx ~/ itemWidth).clamp(0, 2);
        int row = ((localPosition.dy - _getPositionTop()) ~/ itemHeight)
            .clamp(0, (12 ~/ 3));
        int index = row * 3 + col;

        if (index < 12) {
          await _onPadPressed(lessonSounds[index], index);
          setState(() {
            _currentHoverIndex = index;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Drumpad'),
          actions: [
            IconButton(onPressed: isPlaying ? _resetSequence : _startSequence, icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow))
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  key: _widgetPadKey,
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: lessonSounds.length,
                  itemBuilder: (context, index) {
                    final bool hasSound = index < lessonSounds.length;
                    final String soundId = hasSound ? lessonSounds[index] : '';
                    final bool isHighlighted = highlightedSounds.contains(soundId);
                    final sound = lessonSounds[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentHoverIndex = null;
                        });
                        _onPadPressed(sound, index);
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isHighlighted ? Colors.orange : (hasSound ? _getPadColor(soundId) : Colors.grey),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                              child: Text(
                                padStates[sound] ?? "",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          if (padProgress.containsKey(sound))
                            Align(
                              alignment: Alignment.center,
                              child:  SizedBox(
                                width: 36,
                                height: 36,
                                child: CircularProgressIndicator(
                                  value: padProgress[sound],
                                  strokeWidth: 5,
                                  backgroundColor: Colors.white24,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                ),
                              ),
                            ),
                        ],
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
                    lessonSounds.clear();
                    lessonSounds.addAll(sortDrumpadSounds(uniqueSounds.toList(), lessons[index]['events'][0]["notes"][0].contains("_face_b_") ? _faceB : _faceA));
                    // print(lessons[index]['events'][0]["notes"][0].contains("_face_b_") ? _faceB : _faceA);
                  });
                  // print(availableSounds);
                  await _initializeAudioPlayers();
                  _resetSequence();
                  setState(() {
                    isLoading = false;
                  });
                  // Future.delayed(Duration(microseconds: 1000), _startSequence);
                }, child: Text(index.toString(), style: TextStyle(color: index == currentLesson ? Colors.blue : Colors.black)))),
              )
            ],
          ),
        ),
      ),
    );
  }
}