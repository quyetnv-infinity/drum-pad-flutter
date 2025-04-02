import 'dart:async';
import 'dart:convert';

import 'package:drumpad_flutter/core/enum/pad_state_enum.dart';
import 'package:drumpad_flutter/core/utils/pad_util.dart';
import 'package:drumpad_flutter/note.util.dart';
import 'package:drumpad_flutter/sound_type_enum.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/result/result_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class DrumPadScreen extends StatefulWidget {
  final SongCollection? currentSong;
  final Function(int score) onChangeScore;
  final int lessonIndex;
  final void Function()? onChangeUnlockedModeCampaign;
  const DrumPadScreen({super.key, required this.currentSong, required this.onChangeScore, this.lessonIndex = 0, this.onChangeUnlockedModeCampaign});

  @override
  State<DrumPadScreen> createState() => _DrumPadScreenState();
}

class _DrumPadScreenState extends State<DrumPadScreen> with SingleTickerProviderStateMixin {
  List<String> availableSounds = [];
  List<String> lessonSounds = [];
  Map<String, AudioPlayer> audioPlayers = {};
  List<NoteEvent> events = [];
  int currentEventIndex = 0;
  Timer? sequenceTimer;
  bool isPlaying = false;
  Set<String> highlightedSounds = {};
  Set<String> remainSounds = {};
  PadStateEnum firstRemainState = PadStateEnum.none;
  bool notePressed = false;
  double startTimeOffset = 0;
  DateTime? startTime;
  bool isLoading = true;
  double progressValue = 0.0;
  Timer? progressTimer;
  Map<String, double> padProgress = {};

  Map<int, int> _pointerToPadIndex = {};
  Map<int, Offset> _lastPointerPositions = {};
  final double _movementThreshold = 15.0; // Minimum movement
  Map<int, String> _pointerToSound = {};

  String? _currentLeadSound;
  Set<int> _padPressedIndex = {};

  DateTime? lastEventTime;
  DateTime? firstRemainSound;
  Map<String, PadStateEnum> padStates = {};
  List<LessonSequence> lessons = [];
  int currentLesson = 0;

  List<String> _faceA = [];
  List<String> _faceB = [];

  int goodPoint = 0;
  int perfectPoint = 0;
  int latePoint = 0;
  int earlyPoint = 0;
  int missPoint = 0;
  int totalPoint = 0;
  int _previousTotalPoint = 0;

  int _totalNotes = 0;
  Timer? _pauseTimer;

  late AnimationController _controller;

  List<Map<String, dynamic>> _futureNotes = [];

  List<Map<String, dynamic>> getFutureNotes(LessonSequence data) {
    List<Map<String, dynamic>> futureNotes = [];
    List<NoteEvent> events = widget.currentSong?.lessons[widget.lessonIndex].events ?? [];

    for (int i = 1; i < events.length; i++) {
      List<String> notes = events[i].notes;
      if (notes.length >= 2) {
        futureNotes.add({
          "notes": notes,
          "index": i
        });
      }
    }
    return futureNotes;
  }

  @override
  void initState() {
    super.initState();
    if(widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty) {
      _loadSequenceDataFromFile().then((_) {
        _initializeAudioPlayers();
        setState(() {
          isLoading = false;
        });
        // Start sequence if song exists
        if (widget.currentSong != null) {
          _startSequence();
        }
      });
    }
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150), // Thời gian chạy mặc định
    )..repeat();
  }

  @override
  void didUpdateWidget(DrumPadScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Start sequence when song changes from null to non-null
    if (oldWidget.currentSong != widget.currentSong && widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty) {
      print('start');
      _loadSequenceDataFromFile().then((_) {
        _initializeAudioPlayers();
        setState(() {
          isLoading = false;
        });
        // Start sequence if song exists
        _resetSequence();
        _startSequence();
      });
    }
  }

  @override
  void dispose() {
    _disposeAudioPlayers();
    audioPlayers.clear();
    sequenceTimer?.cancel();
    progressTimer?.cancel();
    _controller.dispose();
    _pauseTimer?.cancel();
    super.dispose();
  }

  void resetPoint(){
    print('reset');
    perfectPoint = 0;
    goodPoint = 0;
    latePoint = 0;
    earlyPoint = 0;
    missPoint = 0;
    widget.onChangeScore(0);
  }

  int calculateScore() {
    return perfectPoint * 100 +
      goodPoint * 90 +
      earlyPoint * 60 +
      latePoint * 40 +
      missPoint * 0;
  }

  void _startTimer() {
    _pauseTimer?.cancel();
    _pauseTimer = Timer(Duration(seconds: 5), () {
      if (mounted) {
        _navigateToNextScreen();
      }
    });
  }


  void _navigateToNextScreen() async {
    _pauseTimer?.cancel();
    context.read<DrumLearnProvider>().resetPerfectPoint();
    final result = await Navigator.push(context, CupertinoPageRoute(builder: (context) => ResultScreen(perfectScore: perfectPoint, goodScore: goodPoint, earlyScore: earlyPoint, lateScore: latePoint, missScore: missPoint, totalScore: totalPoint, totalNotes: _totalNotes,),));
    if(result != null && result == 'play_again'){
      _resetSequence(isPlayingDrum: true);
      _startSequence();
      setState(() {
        _previousTotalPoint = 0;
        totalPoint = 0;
      });
    }
  }
  void checkMiss(){
    if (missPoint > 5) _navigateToNextScreen();
  }

  void increasePoint(PadStateEnum state) {
    if(state == PadStateEnum.none) return;
    final provider = context.read<DrumLearnProvider>();

    print("=========================$state");
    switch (state) {
      case PadStateEnum.perfect:
        perfectPoint++;
        provider.increasePerfectPoint();
        break;
      case PadStateEnum.good:
      case PadStateEnum.late:
      case PadStateEnum.early:
      case PadStateEnum.miss:
        if (state == PadStateEnum.good) goodPoint++;
        if (state == PadStateEnum.late) latePoint++;
        if (state == PadStateEnum.early) earlyPoint++;
        if (state == PadStateEnum.miss) missPoint++;

        provider.resetPerfectPoint();
        print('reset perfect');
        break;
      default:
        break;
    }
    if (provider.totalPoint > 0 && provider.totalPoint != _previousTotalPoint) {
      setState(() {
        totalPoint = calculateScore() + provider.totalPoint;
        _previousTotalPoint = provider.totalPoint;
      });
    } else {
      setState(() {
        totalPoint = calculateScore() + _previousTotalPoint;
      });
    }
    checkMiss();
    widget.onChangeScore(totalPoint);
  }

  Future<void> _loadSequenceDataFromFile() async {
    try {
      lessons = widget.currentSong?.lessons ?? [];
      currentLesson = widget.lessonIndex;
      events = lessons[currentLesson].events;
      Set<String> uniqueSounds = {};
      for (var lesson in lessons) {
        for (var event in lesson.events) {
          final notes = event.notes;
          uniqueSounds.addAll(notes);
        }
      }
      availableSounds.addAll(uniqueSounds.toList());
      uniqueSounds = {};
      for (var event in events) {
        final notes = event.notes;
        uniqueSounds.addAll(notes);
        _totalNotes += notes.length;
      }

      _splitSoundsByFace();
      lessonSounds.clear();
      lessonSounds.addAll(sortDrumpadSounds(uniqueSounds.toList(), lessons[currentLesson].events[0].notes[0].contains("_face_b_") ? _faceB : _faceA));
      _futureNotes = getFutureNotes(lessons[currentLesson]);
      print("lessonssss $lessonSounds");
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
    if (!mounted) return;
    for (var player in audioPlayers.values) {
      player.pause();
      player.dispose();
    }
    audioPlayers.clear();
  }

  Future<void> _playSound(String sound) async {
    if (audioPlayers.containsKey(sound)) {
      if(PadUtil.getSoundType(sound) == SoundType.lead){
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
    final nextEventTime = currentEvent.time;
    if (currentEventIndex == 0) {
      startTimeOffset = 0.0;
    } else {
      final prevEvent = events[currentEventIndex - 1];
      startTimeOffset = prevEvent.time;
    }
    final timeUntilEvent = nextEventTime - startTimeOffset;
    sequenceTimer = Timer(Duration(milliseconds: (timeUntilEvent * 1000).round()), () {
      _processEvent(currentEvent);
    });
  }

  void _processEvent(NoteEvent event) {
    setState(() {
      highlightedSounds.clear();
      highlightedSounds.addAll(event.notes);
      progressValue = 0.0;
      padProgress.clear();
    });
    lastEventTime = DateTime.now();
    if (currentEventIndex > events.length - 1) return;

    double currentTime = event.time;
    double prevTime = events[currentEventIndex == 0 ? 0 : currentEventIndex - 1].time;
    double delay = currentTime - prevTime;

    // Nếu nốt đầu tiên có thời gian là 0, thì bỏ qua progress cho nốt này
    if (currentEventIndex == 0 && currentTime == 0) return;

    for (var note in event.notes) {
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
    if(currentEventIndex > 0) _startTimer();
    if(currentEventIndex >= events.length) return;
    if(widget.currentSong == null || widget.currentSong!.lessons.isEmpty) return;
    if(!PadUtil.getPadEnable(sound)) return;

    List<String> requiredNotes = events[currentEventIndex].notes;

    // Add this check to prevent duplicate activations
    if (_padPressedIndex.contains(index)) return;

    setState(() {
      _padPressedIndex.add(index);
    });
    Future.delayed(Duration(milliseconds: 100), (){
      setState(() {
        _padPressedIndex.remove(index);
      });
    },);

    // Rest of the method remains the same
    _playSound(sound);

    lastEventTime ??= DateTime.now();

    double currentTime = (DateTime.now().difference(lastEventTime!).inMilliseconds) / 1000.0;
    double requiredTime = events[currentEventIndex].time - (currentEventIndex > 0 ? events[currentEventIndex - 1].time : 0);

    PadStateEnum state = PadStateEnum.none;
    if(currentEventIndex != 0){
      if (requiredNotes.contains(sound) && currentTime < requiredTime - 0.5) {
        state = PadStateEnum.early;
      } else if (requiredNotes.contains(sound) && currentTime < requiredTime - 0.2) {
        state = PadStateEnum.good;
      } else if (requiredNotes.contains(sound) && currentTime > requiredTime + 0.2) {
        state = PadStateEnum.late;
      } else if (!requiredNotes.contains(sound) && currentEventIndex != 0 && remainSounds.isEmpty){
        state = PadStateEnum.miss;
      } else if (requiredNotes.contains(sound) ) {
        state = PadStateEnum.perfect;
      }
    } else if(requiredNotes.contains(sound) ) {
      state = PadStateEnum.perfect;
      _startTimer();
    }

    setState(() {
      increasePoint(state);
      padStates[sound] = state;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        padStates.remove(sound);
      });
    });
    //
    // if(!requiredNotes.contains(sound) && currentEventIndex != 0){
    //   increasePoint("Miss");
    //   setState(() {
    //     padStates[sound] = 'Miss';
    //   });
    // }
    if (remainSounds.contains(sound)) {
      PadStateEnum state = PadStateEnum.none;
      if(currentEventIndex != 0){
        if (currentTime > 0.2) {
          state = PadStateEnum.miss;
        } else{
          state = firstRemainState;
        }
        remainSounds.remove(sound);
      }
      increasePoint(state);
      setState(() {
        padStates[sound] = state;
      });
    } else if (highlightedSounds.contains(sound)) {
      if (_futureNotes.isNotEmpty && (_futureNotes[0]["notes"] as List).contains(sound) && currentEventIndex != 0) {
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
              padStates[e] = PadStateEnum.miss;
            });
            increasePoint(PadStateEnum.miss);
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                padStates.remove(e);
              });
            });
          }
          remainSounds.clear();
        }
      });
      currentEventIndex++;
      if (currentEventIndex < events.length) {
        _processEvent(events[currentEventIndex]);
      } else {
        highlightedSounds.clear();
        padProgress.clear();
        context.read<DrumLearnProvider>().resetPerfectPoint();
        _pauseTimer?.cancel();
        await Future.delayed(Duration(seconds: 1));
        widget.onChangeUnlockedModeCampaign?.call();
        _navigateToNextScreen();
      }
    }
    //
    // print(currentEventIndex);
    // print(_futureNotes);
    // print("_______");
  }

  double _calculateProgressValue(int currentIndex, int targetIndex) {
    // Calculate how far we are between current and target index
    int distance = targetIndex - currentIndex;

    // Divide the distance into 4 equal steps
    int stepSize = (distance / 4).ceil();
    if (stepSize <= 0) stepSize = 1;

    // Calculate which step we're on (0-3)
    int currentStep = 4 - ((distance + stepSize - 1) ~/ stepSize);
    currentStep = currentStep.clamp(0, 4);

    // Return progress as a value between 0.0 and 1.0
    return (currentStep / 4).clamp(0.0, 1.0);
  }

  List<Color> getPadColor(bool isHighlighted, bool hasSound, bool isActive, String soundId){
    if(widget.currentSong == null || widget.currentSong!.lessons.isEmpty) return [Color(0xFF919191), Color(0xFF5E5E5E)];
    return isHighlighted ? [Color(0xFFEDC78C), Colors.orange] : (hasSound ? PadUtil.getPadGradientColor(isActive, soundId) : [Color(0xFF919191), Color(0xFF5E5E5E)]);
  }

  Future<void> setLessonToPlay(int index) async {
    setState(() {
      isLoading = true;
      currentLesson = index;
      events = lessons[currentLesson].events;
      final Set<String> uniqueSounds = {};
      for (var event in events) {
        final notes = event.notes;
        uniqueSounds.addAll(notes);
      }
      lessonSounds.clear();
      lessonSounds.addAll(sortDrumpadSounds(uniqueSounds.toList(), lessons[index].events[0].notes[0].contains("_face_b_") ? _faceB : _faceA));
      // print(lessons[index]['events'][0]["notes"][0].contains("_face_b_") ? _faceB : _faceA);
    });
    // print(availableSounds);
    await _initializeAudioPlayers();
    _resetSequence();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: currentEventIndex >= events.length,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          if(!(widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty)) return;
          // Track new pointer
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset localPosition = box.globalToLocal(event.position);
          _lastPointerPositions[event.pointer] = localPosition;

          // Calculate which pad was touched
          double itemWidth = box.size.width / 3;
          double itemHeight = itemWidth;
          int col = (localPosition.dx ~/ itemWidth).clamp(0, 2);
          int row = ((localPosition.dy) ~/ itemHeight)
              .clamp(0, (12 ~/ 3));
          int index = row * 3 + col;
          // print(index);

          if (index < 12) {
            _pointerToPadIndex[event.pointer] = index;
            _pointerToSound[event.pointer] = lessonSounds[index];
          }
        },

        onPointerUp: (event) {
          if(!(widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty)) return;
          // Clean up when pointer is released
          _pointerToPadIndex.remove(event.pointer);
          _pointerToSound.remove(event.pointer);
          _lastPointerPositions.remove(event.pointer);
        },
        onPointerMove: (event) async {
          if(!(widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty)) return;
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset localPosition = box.globalToLocal(event.position);

          // Check if this pointer has moved enough to trigger a new pad
          if (_lastPointerPositions.containsKey(event.pointer)) {
            double distance = (localPosition - _lastPointerPositions[event.pointer]!).distance;
            if (distance < _movementThreshold) {
              return; // Movement too small, ignore
            }
          }

          double itemWidth = box.size.width / 3;
          double itemHeight = itemWidth;
          int col = (localPosition.dx ~/ itemWidth).clamp(0, 2);
          int row = ((localPosition.dy) ~/ itemHeight)
              .clamp(0, (12 ~/ 3));
          int index = row * 3 + col;

          // Only process if index is valid
          if (index < 12) {
            String currentSound = lessonSounds[index];

            // Check if this pointer is already on this pad or has already played this sound
            if (_pointerToPadIndex[event.pointer] == index ||
                _pointerToSound[event.pointer] == currentSound) {
              return; // Already on this pad or already played this sound
            }

            _pointerToPadIndex[event.pointer] = index;
            _pointerToSound[event.pointer] = currentSound;
            _lastPointerPositions[event.pointer] = localPosition;

            _onPadPressed(currentSound, index);
          }
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          physics: NeverScrollableScrollPhysics(),
          itemCount: 12,
          itemBuilder: (context, index) {
            final bool hasSound = index < lessonSounds.length && widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty;
            final String soundId = hasSound && lessonSounds.length == 12 ? lessonSounds[index] : '';
            final bool isHighlighted = highlightedSounds.contains(soundId);
            final sound = lessonSounds.length == 12 ? lessonSounds[index] : '';
            bool isActive = _padPressedIndex.isNotEmpty && _padPressedIndex.contains(index) && widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty;
            return GestureDetector(
              onTapDown: (_) {
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
                          borderRadius: BorderRadius.circular(12.0),
                          gradient: RadialGradient(colors: getPadColor(isHighlighted, hasSound, isActive, soundId))
                      ),
                    ),
                  ),
                  Center(
                    child: TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(begin: 1.0, end: isActive ? 2.5 : 1.0),
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeInOut,
                            transform: Matrix4.translationValues(0, padStates[sound] != null ? -80 : 0, 0),
                            child: (padStates[sound] ?? PadStateEnum.none).getDisplayWidget(context),
                          ),
                        );
                      },
                    ),
                  ),
                  // (padStates[sound] ?? PadStateEnum.none).getDisplayWidget(context),
                  if (_futureNotes.isNotEmpty
                      && (_futureNotes[0]["notes"] as List).contains(sound)
                      && currentEventIndex != 0
                      && !padProgress.containsKey(sound)
                      && !sound.contains("drums")
                      && _futureNotes[0]["index"] - currentEventIndex < 4
                  )
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            value: _calculateProgressValue(currentEventIndex, _futureNotes[0]["index"]),
                            strokeWidth: 5,
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Text("Wait", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white))),

                      ],
                    ),
                  if (padProgress.containsKey(sound) && hasSound)
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
                    Lottie.asset('assets/anim/lightning_button.json', fit: BoxFit.cover, controller: _controller),
                  if(!padProgress.containsKey(sound) && isHighlighted)
                    Align(
                        alignment: Alignment.center,
                        child: Lottie.asset('assets/anim/click_here.json', height: MediaQuery.sizeOf(context).width /3 - 50))
                ],
              ),
            );
          },
        )
      ),
    );
  }

}