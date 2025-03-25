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
  Set<String> remainSounds = {};
  String firstRemainState = '';
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
  Set<int> _padPressedIndex = {};

  DateTime? lastEventTime;
  DateTime? firstRemainSound;
  Map<String, String> padStates = {};
  List<dynamic> lessons = [];
  int currentLesson = 0;

  List<String> _faceA = [];
  List<String> _faceB = [];

  int goodPoint = 0;
  int perfectPoint = 1;
  int latePoint = 0;
  int earlyPoint = 0;
  int missPoint = 0;

  List<Map<String, dynamic>> _futureNotes = [];

  List<Map<String, dynamic>> getFutureNotes(Map<String, dynamic> data) {
    List<Map<String, dynamic>> futureNotes = [];
    List<Map<String, dynamic>> events = List<Map<String, dynamic>>.from(data["events"]);

    for (int i = 1; i < events.length; i++) {
      List<String> notes = List<String>.from(events[i]["notes"]);
      if (notes.length >= 2) {
        futureNotes.add({
          "notes": notes,
          "index": i
        });
      }
    }
    return futureNotes;
  }

  final Map<String, Color> soundColors = {
    'lead': Colors.redAccent,
    'bass': Colors.lightGreen,
    'drums': Colors.lightBlue,
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

  void resetPoint(){
    perfectPoint = 1;
    goodPoint = 0;
    latePoint = 0;
    earlyPoint = 0;
    missPoint = 0;
  }
  void increasePoint(String state){
    switch(state){
      case 'Perfect':
        perfectPoint++;
        break;
      case 'Gud':
        goodPoint++;
        break;
      case 'Late':
        latePoint++;
        break;
      case 'Early':
        earlyPoint++;
        break;
      case 'Miss':
        missPoint++;
        break;
    }
  }

  void showDialogPoint(){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Result"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Perfect: $perfectPoint"),
            Text("Good: $goodPoint"),
            Text("Late: $latePoint"),
            Text("Early: $earlyPoint"),
            Text("Miss: $missPoint"),
          ],
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("OK"))
        ],
      );
    },);
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
      _futureNotes = getFutureNotes(lessons[currentLesson]);
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

  Future<void> _playSound(String sound) async {
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
    resetPoint();
    if (isPlaying || events.isEmpty) return;
    _resetSequence();
    setState(() {
      isPlaying = true;
    });
    _scheduleNextEvent();
  }

  void _resetSequence({bool isPlayingDrum = false}) {
    _futureNotes = getFutureNotes(lessons[currentLesson]);
    for (var player in audioPlayers.values) {
      if(!isPlayingDrum) player.pause();
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

  void _onPadPressed(String sound, int index) {
    if(_getPadColor(sound) == Colors.grey) return;
    if (_currentHoverIndex == index) return;
    setState(() {
      _padPressedIndex.add(index);
    });
    Future.delayed(Duration(milliseconds: 100), (){
      setState(() {
        _padPressedIndex.remove(index);
      });
    },);
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

    increasePoint(state);

    setState(() {
      padStates[sound] = state;
      // print(firstRemainState);

      // highlightedSounds.remove(sound);
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        padStates.remove(sound);
      });
    });

    List<String> requiredNotes = List<String>.from(events[currentEventIndex]['notes']);
    if(!requiredNotes.contains(sound) && currentEventIndex != 0){
      increasePoint("Miss");
      setState(() {
        padStates[sound] = 'Miss';
      });
    }

    if (highlightedSounds.contains(sound) ) {
      if (_futureNotes.isNotEmpty && (_futureNotes[0]["notes"] as List).contains(sound)) {
        _futureNotes.removeAt(0);
        setState(() {});
      }
      firstRemainSound = DateTime.now();

      remainSounds.clear();
      for (var remainingSound in highlightedSounds) {
        if (remainingSound != sound) {
          remainSounds.add(remainingSound);
          setState(() {
            firstRemainState = state;
          });
        }
      }
      Future.delayed(Duration(milliseconds: 200),() {
        if(remainSounds.isNotEmpty){
          for (var e in remainSounds) {
            setState(() {
              padStates[e] = 'Miss';
            });
            increasePoint("Miss");
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                padStates.remove(e);
              });
            });
          }
        }
      });
      currentEventIndex++;
      if (currentEventIndex < events.length) {
        _processEvent(events[currentEventIndex]);
      } else {
        _resetSequence(isPlayingDrum: true);
        showDialogPoint();
      }
    } else if (remainSounds.contains(sound)){
      double currentTime = (DateTime.now().difference(firstRemainSound!).inMilliseconds) / 1000.0;
      String state = "";
      if(currentEventIndex != 0){
        if (currentTime > 0.2) {
          state = 'Miss';
        } else{
          state = firstRemainState;
        }
        remainSounds.remove(sound);
      }
      setState(() {
        padStates[sound] = state;
      });
      increasePoint(state);
      print(padStates[sound]);
    }
    //
    // if (highlightedSounds.contains(sound)) {
    //   // for (var remainingSound in highlightedSounds) {
    //   //   if (remainingSound != sound) {
    //   //     _playSound(remainingSound);
    //   //   }
    //   // }
    //
    //   highlightedSounds.remove(sound);
    //   currentEventIndex++;
    //   if (currentEventIndex < events.length) {
    //     _processEvent(events[currentEventIndex]);
    //   } else {
    //     _resetSequence(); // Kết thúc nếu không còn sự kiện nào
    //   }
    // }

    // lastEventTime = DateTime.now();
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
          _onPadPressed(lessonSounds[index], index);
          setState(() {
            _currentHoverIndex = index;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Drumpad', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(onPressed: isPlaying ? _resetSequence : _startSequence, icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white,))
          ],
          backgroundColor: Colors.black,
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
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: lessonSounds.length,
                  itemBuilder: (context, index) {
                    final bool hasSound = index < lessonSounds.length;
                    final String soundId = hasSound ? lessonSounds[index] : '';
                    final bool isHighlighted = highlightedSounds.contains(soundId);
                    final sound = lessonSounds[index];
                    bool isActive = _padPressedIndex.isNotEmpty && _padPressedIndex.contains(index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentHoverIndex = null;
                        });
                        _onPadPressed(sound, index);
                      },
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.all(isActive ? 8 : 0),
                            child: Container(
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
                          ),
                          if (_futureNotes.isNotEmpty && (_futureNotes[0]["notes"] as List).contains(sound) && currentEventIndex != 0 && !padProgress.containsKey(sound) && !sound.contains("drums"))
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    value: (currentEventIndex + 1) / (_futureNotes[0]["index"] + 1),
                                    strokeWidth: 5,
                                    backgroundColor: Colors.white24,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Text("Wait", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white)))
                              ],
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
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                            ),
                          if (isActive)
                            TweenAnimationBuilder<double>(
                              duration: Duration(milliseconds: 100),
                              tween: Tween(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Container(
                                  margin: EdgeInsets.all(40*(1 - value)),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 2),
                                    shape: BoxShape.circle
                                  ),
                                );
                              },
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
                }, child: Text(index.toString(), style: TextStyle(color: index == currentLesson ? Colors.blue : Colors.white)))),
              )
            ],
          ),
        ),
      ),
    );
  }
}