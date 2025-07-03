import 'dart:async';
import 'dart:math';
import 'package:and_drum_pad_flutter/core/enum/pad_state_enum.dart';
import 'package:and_drum_pad_flutter/core/enum/sound_type_enum.dart';
import 'package:and_drum_pad_flutter/core/utils/note.util.dart';
import 'package:and_drum_pad_flutter/core/utils/pad_util.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/data/model/theme_model.dart';
import 'package:and_drum_pad_flutter/data/service/media_recorder_service.dart';
import 'package:and_drum_pad_flutter/data/service/screen_record_service.dart';
import 'package:and_drum_pad_flutter/view/screen/result/result_screen.dart';
import 'package:and_drum_pad_flutter/view_model/campaign_provider.dart';
import 'package:and_drum_pad_flutter/view_model/drum_learn_provider.dart';
import 'package:and_drum_pad_flutter/view_model/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:provider/provider.dart';
import 'drum_pad_item.dart';

class DrumPadScreen extends StatefulWidget {
  final SongCollection? currentSong;
  final Function(int score) onChangeScore;
  final Function(double star)? onChangeStarLearn;
  final int lessonIndex;
  final void Function()? onChangeUnlockedModeCampaign;
  final void Function(double star)? onChangeCampaignStar;
  final String? practiceMode;
  final bool isFromLearnScreen;
  final bool isFromCampaign;
  final Function(SongCollection song)? onTapChooseSong;
  final VoidCallback? onResetRecordingToggle;
  final void Function(VoidCallback pauseHandler)? onRegisterPauseHandler;
  final void Function(VoidCallback startHandler)? onRegisterStartHandler;
  final void Function(bool isPlaying)? onChangePlayState;
  final void Function(int perfectPoint)? onChangePerfectPoint;
  final bool? isPause;
  final bool isFreeStyle;

  const DrumPadScreen({super.key, required this.currentSong, required this.onChangeScore, this.lessonIndex = 0, this.onChangeUnlockedModeCampaign, this.practiceMode, this.onChangeCampaignStar, this.onChangeStarLearn, required this.isFromLearnScreen, this.onTapChooseSong, required this.isFromCampaign, this.onResetRecordingToggle, this.onRegisterPauseHandler, this.onChangePlayState, this.onChangePerfectPoint, this.isPause, this.onRegisterStartHandler, this.isFreeStyle = false});

  @override
  State<DrumPadScreen> createState() => _DrumPadScreenState();
}

class _DrumPadScreenState extends State<DrumPadScreen> with TickerProviderStateMixin {
  List<String> availableSounds = [];
  List<String> lessonSounds = [];
  Map<String, AudioSource> audioSources = {};
  Map<String, SoundHandle?> currentlyPlayingSounds = {};
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
  String? _currentBassSound;
  Set<int> _padPressedIndex = {};

  DateTime? lastEventTime;
  DateTime? firstRemainSound;
  Map<String, PadStateEnum> padStates = {};
  List<LessonSequence> lessons = [];
  int currentLesson = 0;

  bool isNavigatedToResult = false;

  List<String> _faceA = [];
  List<String> _faceB = [];

  int goodPoint = 0;
  int perfectPoint = 0;
  int latePoint = 0;
  int earlyPoint = 0;
  int missPoint = 0;
  int totalPoint = 0;
  int _previousTotalPoint = 0;
  int tempLessonIndex = 0;

  int _totalNotes = 0;
  Timer? _pauseTimer;
  bool _isFromBeatRunner = false;

  late AnimationController _controller;
  Map<int, AnimationController> _colorControllers = {};
  Map<int, Animation<Color?>> _colorAnimations = {};

  List<Map<String, dynamic>> _futureNotes = [];

  late ThemeModel currentTheme;

  // SoLoud instance
  late SoLoud _soloud;
  bool _soloudInitialized = false;

  List<Map<String, dynamic>> getFutureNotes(LessonSequence data) {
    List<Map<String, dynamic>> futureNotes = [];
    List<NoteEvent> events = widget.currentSong?.lessons[currentLesson].events ?? [];

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
    _initializeSoloud();
    currentTheme = Provider.of<ThemeProvider>(context, listen: false).currentTheme;
    _isFromBeatRunner = !widget.isFromCampaign && !widget.isFromLearnScreen;
    if(widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      // load time and events from file
      _loadSequenceDataFromFile(widget.lessonIndex).then((_) async{
        await _initializeAudioSources();
        setState(() {
          isLoading = false;
        });
        // Start sequence if song exists
        if (widget.currentSong != null) {
          _startSequence();
        }
      });
    } else if(widget.currentSong == null) {
      _initFreeStyleSongDefault();
    }
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150), // Thời gian chạy mặc định
    )..repeat();
    if(widget.currentSong != null) context.read<DrumLearnProvider>().addBeatRunnerSongComplete(widget.currentSong!.id);
    widget.onRegisterPauseHandler?.call(pause);
    widget.onRegisterStartHandler?.call(_startTimer);
  }

  Future<void> _initializeSoloud() async {
    print('Initializing SoLoud...');
    try {
      _soloud = SoLoud.instance;
      await _soloud.init();
      setState(() {
        _soloudInitialized = true;
      });
    } catch (e) {
      print('Error initializing SoLoud: $e');
    }
  }

  Future<void> _initFreeStyleSongDefault() async {
    if(!_soloudInitialized) await _initializeSoloud();

    _disposeAudioSources();
    availableSounds = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];
    lessonSounds = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];

    for (String sound in availableSounds) {
      if (sound.isEmpty) continue;
      try {
        final source = await _soloud.loadAsset('assets/audio/$sound.wav');
        audioSources[sound] = source;
      } catch (e) {
        print('Error loading audio file for $sound: $e at assets/audio/$sound.wav');
        continue;
      }
    }
  }

  @override
  void didUpdateWidget(DrumPadScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Start sequence when song changes from null to non-null
    if (oldWidget.currentSong != widget.currentSong && widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty) {
      print('reload song');
      setState(() {
        isLoading = true;
      });
      _loadSequenceDataFromFile(widget.lessonIndex).then((_) async{
        await _initializeAudioSources();
        setState(() {
          isLoading = false;
        });
        // Start sequence if song exists
        _resetSequence();
        _startSequence();
      });
    }else if(widget.currentSong == null) {
      _initFreeStyleSongDefault();
    }
    checkModeChange(oldWidget);
  }

  @override
  void dispose() {
    for (var controller in _colorControllers.values) {
      controller.dispose();
    }
    _disposeAudioSources();
    audioSources.clear();
    sequenceTimer?.cancel();
    progressTimer?.cancel();
    _controller.dispose();
    _pauseTimer?.cancel();
    if (_soloudInitialized) {
      _soloud.deinit();
    }
    super.dispose();
  }

  List<Color> colorsPad = [Color(0xFFC3FF80), Color(0xFF80EAFF), Color(0xFF80FFEE), Color(0xFFD880FF)];
  void _startColorAnimation(int pressedIndex, String sound) {
    if (!mounted) return;
    if(!_isFromBeatRunner) return;
    try {
      // Clear previous animations safely
      for (var controller in _colorControllers.values) {
        controller.dispose();
      }
      _colorControllers.clear();
      _colorAnimations.clear();

      // Calculate distances and delays for each pad
      for (int i = 0; i < 12; i++) {
        if (i == pressedIndex) continue;

        final controller = AnimationController(
          duration: Duration(milliseconds: 1000),
          vsync: this,
        );

        var random = Random();
        Color randomColor = colorsPad[random.nextInt(colorsPad.length)];
        final animation = ColorTween(
          begin: randomColor.withValues(alpha: 0.9),
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutQuad,
        ));

        _colorControllers[i] = controller;
        _colorAnimations[i] = animation;

        // Safe animation start with delay
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted &&
              _colorControllers[i] != null &&
              !_colorControllers[i]!.isAnimating) {
            _colorControllers[i]!.forward().then((_) {
              if (mounted) {
                _colorControllers[i]?.dispose();
                setState(() {
                  _colorControllers.remove(i);
                  _colorAnimations.remove(i);
                });
              }
            });
          }
        });
      }
    } catch (e) {
      print('Color animation error: $e');
    }
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
      if (mounted && widget.practiceMode != 'practice') {
        _navigateToNextScreen();
      }
    });
  }
  void pause() {
    _pauseTimer?.cancel();
    print('pauseTimer cancelled!');
  }

  int getLastIndexOfCurrentFace(){
    bool isFaceA = lessons[currentLesson].events.first.notes.first.contains('face_a');
    if(isFaceA){
      for(var i = 0; i < lessons.length; i++){
        if(lessons[i].events.first.notes.first.contains('face_b')){
          return i - 1;
        }
      }
    }
    return lessons.length - 1;

  }

  void checkModeChange(DrumPadScreen oldWidget){
    if (oldWidget.practiceMode != widget.practiceMode && widget.practiceMode == "practice") {
      setState(() {
        _totalNotes = 0;
        tempLessonIndex = currentLesson;
      });
      int lastLessonOfCurrentFace = getLastIndexOfCurrentFace();
      print(lastLessonOfCurrentFace);
      _loadSequenceDataFromFile(lastLessonOfCurrentFace).then((_) {
        setState(() {
          _pauseTimer?.cancel();
          isLoading = false;
        });
        // Start sequence if song exists
        _resetSequence();
        _startSequence();
        widget.onChangeStarLearn?.call(0);
        widget.onChangePerfectPoint?.call(0);
      });
    }else if(oldWidget.practiceMode != widget.practiceMode && widget.practiceMode != "practice"){
      setState(() {
        _totalNotes = 0;
      });
      _loadSequenceDataFromFile(tempLessonIndex).then((_) {
        setState(() {
          isLoading = false;
        });
        _resetSequence();
        _startSequence();
        widget.onChangeStarLearn?.call(0);
        widget.onChangePerfectPoint?.call(0);
      });
    }
  }

  Future<void> _updateScoreForBeatLearn(DrumLearnProvider provider) async {
    final song = await provider.getSong(widget.currentSong!.id);
    if(song != null) {
      List<LessonSequence> _lessons = song.lessons;
      LessonSequence _lesson = _lessons[currentLesson];
      final newLesson = _lesson.copyWith(totalScore: totalPoint*1.0);
      print('totalScore: $totalPoint');
      _lessons[currentLesson] = newLesson;
      print('new score: ${_lessons[currentLesson].totalScore}');
      await provider.updateSong(widget.currentSong!.id, song.copyWith(lessons: _lessons));
    }
  }

  Future<void> _updateScoreForCampaign(CampaignProvider campaignProvider) async {
    final song = await campaignProvider.getSong(widget.currentSong!.id);
    if(song != null) {
      final updatedSong = song.copyWith(campaignScore: totalPoint*1.0, campaignStar: getStar());
      await campaignProvider.updateSong(widget.currentSong!.id, updatedSong);
    }
  }

  void _navigateToNextScreen() async {
    if(isNavigatedToResult) return;
    setState(() {
      isNavigatedToResult = true;
    });
    final provider = context.read<DrumLearnProvider>();
    final campaignProvider = Provider.of<CampaignProvider>(context, listen: false);
    /// check is last for a song or for a campaign
    final checkLastCampaign = (campaignProvider.currentSongCampaign >= campaignProvider.currentCampaign.length - 1 && widget.isFromCampaign) || (currentLesson >= lessons.length - 1 && widget.isFromLearnScreen);
    _pauseTimer?.cancel();
    widget.onChangePerfectPoint!(0);
    /// 👀 check stop record
    if (provider.isRecording) {
      await MediaRecorderService.stopInternalRecording();
    }
    widget.onChangeCampaignStar?.call(getStar());
    widget.onResetRecordingToggle?.call();
    /// 📌 check condition of result to save unlocked lesson or campaign and save star
    if(getStar() >= 2) {
      widget.onChangeUnlockedModeCampaign?.call();
    }
    /// 📖 save learn from song and beat runner count for information at profile screen
    if (!widget.isFromLearnScreen && !widget.isFromCampaign) {
      provider.addBeatRunnerStar(widget.currentSong!.id, getStar());
    } else if(widget.isFromLearnScreen){
      await _updateScoreForBeatLearn(provider);
    } else if (widget.isFromCampaign) {
      await _updateScoreForCampaign(campaignProvider);
    }
    if (currentLesson >= lessons.length - 1 && widget.isFromLearnScreen) provider.addLearnSongComplete(widget.currentSong!.id);
    /// push navigation and check cases
    checkPointsExceed();
    /// show result dialog
    final result = await
      showDialog(context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.9),
        builder: (context) => Dialog(

        backgroundColor: Colors.transparent,
        child: ResultScreen(perfectScore: perfectPoint, goodScore: goodPoint, earlyScore: earlyPoint, lateScore: latePoint, missScore: missPoint, totalScore: totalPoint, totalNotes: _totalNotes, isFromLearn: widget.isFromLearnScreen, isFromCampaign: widget.isFromCampaign, currentLesson: currentLesson, maxLesson: lessons.length, isCompleted: getStar() >= 2, isCompleteCampaign: checkLastCampaign,)));

    setState(() {
      isNavigatedToResult = false;
    });
    if(result != null && result == 'play_again'){
      final tempTotalNote = _totalNotes;
      widget.onChangeStarLearn?.call(0);
      _resetSequence(isPlayingDrum: true);
      _startSequence();
      setState(() {
        _previousTotalPoint = 0;
        totalPoint = 0;
        _totalNotes = tempTotalNote;
      });
    }
    /// that case which check for back to Beat Runner screen and choose another song
    else if(result != null && result is SongCollection && !widget.isFromCampaign && !widget.isFromLearnScreen){
      widget.onTapChooseSong?.call(result);
      widget.onChangeStarLearn?.call(0);
      _resetSequence(isPlayingDrum: true);
      _startSequence();
      setState(() {
        _previousTotalPoint = 0;
        totalPoint = 0;
      });
    }
    /// next Lesson
    else if(result != null && result is int){
      final campaignProvider = Provider.of<CampaignProvider>(context, listen: false);
      setState(() {
        if(widget.isFromLearnScreen) {
          currentLesson = result;
        }
        // print(' result pop $result');
      });
      if(widget.isFromLearnScreen) campaignProvider.setCurrentLessonCampaign(currentLesson);
      widget.onChangeStarLearn?.call(0);
      _resetSequence(isPlayingDrum: true);
      setState(() {
        _previousTotalPoint = 0;
        totalPoint = 0;
        isLoading = true;
      });
      _loadSequenceDataFromFile(currentLesson).then((_) async {
        await _initializeAudioSources();
        setState(() {
          isLoading = false;
        });
        // Start sequence if song exists
        if (widget.currentSong != null) {
          _startSequence();
        }
      });
    } /// next campaign
    else if(result != null && result is SongCollection){
      setState(() {
        if(widget.isFromCampaign) {
          currentLesson = 0;
        }
      });
      print('========resutl next campaign ${result.name}');
      widget.onTapChooseSong?.call(result);
      print('========${result.name}');
      widget.onChangeStarLearn?.call(0);
      _resetSequence(isPlayingDrum: true);
      setState(() {
        _previousTotalPoint = 0;
        totalPoint = 0;
        isLoading = true;
      });
      _loadSequenceDataFromFile(currentLesson).then((_) async {
        await _initializeAudioSources();
        setState(() {
          isLoading = false;
        });
        // Start sequence if song exists
        if (widget.currentSong != null) {
          _startSequence();
        }
      });
    }
  }

  double getStar(){
    final percent = (totalPoint / (_totalNotes * 100))*100;
    switch(percent){
      case < 30:
        return 0;
      case < 60:
        return 1;
      case < 90:
        return 2;
      default:
        return 3;
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
        /// PERFECT POINT
        widget.onChangePerfectPoint?.call(1);
        break;
      case PadStateEnum.good:
      case PadStateEnum.late:
      case PadStateEnum.early:
      case PadStateEnum.miss:
        if (state == PadStateEnum.good) goodPoint++;
        if (state == PadStateEnum.late) latePoint++;
        if (state == PadStateEnum.early) earlyPoint++;

        widget.onChangePerfectPoint?.call(0);
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

  Future<void> _loadSequenceDataFromFile(int lesson) async {
    try {
      _totalNotes = 0;
      /// check beat runner or drum learn/campaign
      lessons = (!widget.isFromCampaign && !widget.isFromLearnScreen) ? (widget.currentSong?.beatRunnerLessons ?? []) : (widget.currentSong?.lessons ?? []);
      currentLesson = widget.isFromCampaign ? lessons.length - 1 : lesson;
      events = lessons[currentLesson].events;
      Set<String> uniqueSounds = {};
      for (var lesson in lessons) {
        for (var event in lesson.events) {
          final notes = event.notes;
          uniqueSounds.addAll(notes);
        }
      }
      availableSounds.clear();
      availableSounds.addAll(uniqueSounds.toList());
      uniqueSounds = {};
      int countNote = 0;
      for (var event in events) {
        final notes = event.notes;
        uniqueSounds.addAll(notes);
        countNote += notes.length;
      }
      // print(uniqueSounds);
      // print('totalNotes $countNote');
      _totalNotes = countNote;

      _splitSoundsByFace();
      lessonSounds.clear();
      lessonSounds.addAll(sortDrumpadSounds(uniqueSounds.toList(), lessons[currentLesson].events[0].notes[0].contains("_face_b_") ? _faceB : _faceA));
      _futureNotes = getFutureNotes(lessons[currentLesson]);
      // print(_futureNotes);
      print("lessonssss $lessonSounds");
      print(events.first.notes);
    } catch (e) {
      print('Error loading sequence data from file: $e');
      events = [];
      availableSounds.clear();
      lessonSounds.clear();
    }
  }

  Future<void> _initializeAudioSources() async {
    if(!_soloudInitialized) await _initializeSoloud();
    if (!_soloudInitialized) return;

    _disposeAudioSources();
    final pathDir = context.read<DrumLearnProvider>().pathDir;
    for (String sound in availableSounds) {
      if (sound.isEmpty) continue;
      try {
        final source = await _soloud.loadFile('$pathDir/${widget.currentSong?.id}/$sound.mp3');
        print('Loaded sound: $sound from $pathDir/${widget.currentSong?.id}/$sound.mp3');
        audioSources[sound] = source;
      } catch (e) {
        print('Error loading audio file for $sound: $e at $pathDir/${widget.currentSong?.id}/$sound.mp3');

        // Try to reload the song data
        if (widget.onTapChooseSong != null && widget.currentSong != null) {
          widget.onTapChooseSong?.call(widget.currentSong!);
        }
        continue;
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

  void _disposeAudioSources() {
    if (!mounted || !_soloudInitialized) return;

    // Stop all playing sounds
    for (var handle in currentlyPlayingSounds.values) {
      if (handle != null) {
        _soloud.stop(handle);
      }
    }
    currentlyPlayingSounds.clear();

    // Dispose audio sources
    for (var source in audioSources.values) {
      _soloud.disposeSource(source);
    }
    audioSources.clear();
  }

  Future<void> _playSound(String sound) async {
    if (!_soloudInitialized) return;

    // Stop previous sounds based on type
    if(_isFromBeatRunner){
      if(currentlyPlayingSounds[_currentLeadSound ?? ''] != null) {
        _soloud.stop(currentlyPlayingSounds[_currentLeadSound ?? '']!);
      }
      setState(() {
        _currentLeadSound = sound;
      });
    } else if(PadUtil.getSoundType(sound) == SoundType.lead){
      if(currentlyPlayingSounds[_currentLeadSound ?? ''] != null) {
        _soloud.stop(currentlyPlayingSounds[_currentLeadSound ?? '']!);
      }
      setState(() {
        _currentLeadSound = sound;
      });
    }else if (PadUtil.getSoundType(sound) == SoundType.bass){
      if(currentlyPlayingSounds[_currentBassSound ?? ''] != null) {
        _soloud.stop(currentlyPlayingSounds[_currentBassSound ?? '']!);
      }
      setState(() {
        _currentBassSound = sound;
      });
    }

    // Play new sound
    if (audioSources.containsKey(sound)) {
      final handle = await _soloud.play(audioSources[sound]!);
      currentlyPlayingSounds[sound] = handle;
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
    widget.onChangePlayState?.call(false);
  }

  void _resetSequence({bool isPlayingDrum = false}) {
    _futureNotes = getFutureNotes(lessons[currentLesson]);
    if (!isPlayingDrum && _soloudInitialized) {
      // Stop all playing sounds
      for (var handle in currentlyPlayingSounds.values) {
        if (handle != null) {
          _soloud.stop(handle);
        }
      }
      currentlyPlayingSounds.clear();
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
      startTimeOffset = events[0].time;
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
    // if (currentEventIndex == 0 && currentTime == 0) return;

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
    if(currentEventIndex >= events.length && !widget.isFreeStyle) return;
    if((widget.currentSong == null || widget.currentSong!.lessons.isEmpty) && !widget.isFreeStyle) return;
    if(!PadUtil.getPadEnable(sound) && !widget.isFreeStyle) return;
    _startColorAnimation(index, sound);
    _startTimer();

    List<String> requiredNotes = !widget.isFreeStyle ? events[currentEventIndex].notes : [];
    // Add this check to prevent duplicate activations
    if (_padPressedIndex.contains(index) && !widget.isFreeStyle) return;

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
    if(widget.practiceMode == 'practice'){
      return;
    }
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
      widget.onChangePlayState?.call(true);
      state = PadStateEnum.perfect;
    }

    setState(() {
      increasePoint(state);
      if(state == PadStateEnum.miss) missPoint++;
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
    if (remainSounds.contains(sound) ) {
      PadStateEnum state = PadStateEnum.none;
      if(currentEventIndex != 0){
        if (currentTime > 0.2) {
          state = PadStateEnum.miss;
        } else{
          state = firstRemainState;
        }
        remainSounds.remove(sound);
      }
      print('remains $remainSounds');
      increasePoint(state);
      setState(() {
        padStates[sound] = state;
      });
    } else if (highlightedSounds.contains(sound)) {
      if (_futureNotes.isNotEmpty && (_futureNotes[0]["notes"] as List).contains(sound) && currentEventIndex == (_futureNotes[0]["index"] as int) && currentEventIndex != 0) {
        print('remove=========');
        setState(() {
          _futureNotes.removeAt(0);
        });
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
      widget.onChangeStarLearn?.call((totalPoint / (_totalNotes * 100))*100);
      currentEventIndex++;
      if (currentEventIndex < events.length) {
        _processEvent(events[currentEventIndex]);
      } else {
        highlightedSounds.clear();
        padProgress.clear();
        widget.onChangePerfectPoint?.call(0);
        _pauseTimer?.cancel();
        await Future.delayed(Duration(seconds: 1));
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
    if(widget.isFreeStyle) return PadUtil.getPadGradientColor(isActive, soundId, currentTheme, isFreeStyle: true);
    if(widget.currentSong == null || widget.currentSong!.lessons.isEmpty) return [Color(0xFFe099ff).withValues(alpha: 0.4), Color(0xFFc84bff).withValues(alpha: 0.4)];
    return isHighlighted && widget.practiceMode != 'practice' ? [Color(0xFFEDC78C), Colors.orange] : (hasSound ? PadUtil.getPadGradientColor(isActive, soundId, currentTheme) : [Color(0xFF919191), Color(0xFF5E5E5E)]);
  }

  void checkPointsExceed() {
    final totalPoints = perfectPoint + goodPoint + earlyPoint + latePoint + missPoint;
    if (totalPoints > _totalNotes) {
      int exceed = totalPoints - _totalNotes;
      final pointMap = {
        'perfect': perfectPoint,
        'good': goodPoint,
        'early': earlyPoint,
        'late': latePoint,
        'miss': missPoint,
      };
      final sortedEntries = pointMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final firstKey = sortedEntries[0].key;
      final secondKey = sortedEntries[1].key;
      final firstReduction = (exceed * 0.6).round();
      final secondReduction = exceed - firstReduction;
      switch (firstKey) {
        case 'perfect': perfectPoint -= firstReduction; break;
        case 'good': goodPoint -= firstReduction; break;
        case 'early': earlyPoint -= firstReduction; break;
        case 'late': latePoint -= firstReduction; break;
        case 'miss': missPoint -= firstReduction; break;
      }
      switch (secondKey) {
        case 'perfect': perfectPoint -= secondReduction; break;
        case 'good': goodPoint -= secondReduction; break;
        case 'early': earlyPoint -= secondReduction; break;
        case 'late': latePoint -= secondReduction; break;
        case 'miss': missPoint -= secondReduction; break;
      }
      perfectPoint = perfectPoint.clamp(0, double.infinity).toInt();
      goodPoint = goodPoint.clamp(0, double.infinity).toInt();
      earlyPoint = earlyPoint.clamp(0, double.infinity).toInt();
      latePoint = latePoint.clamp(0, double.infinity).toInt();
      missPoint = missPoint.clamp(0, double.infinity).toInt();
    }
  }


  // Future<void> setLessonToPlay(int index) async {
  //   setState(() {
  //     isLoading = true;
  //     currentLesson = index;
  //     events = lessons[currentLesson].events;
  //     final Set<String> uniqueSounds = {};
  //     for (var event in events) {
  //       final notes = event.notes;
  //       uniqueSounds.addAll(notes);
  //     }
  //     lessonSounds.clear();
  //     lessonSounds.addAll(sortDrumpadSounds(uniqueSounds.toList(), lessons[index].events[0].notes[0].contains("_face_b_") ? _faceB : _faceA));
  //     // print(lessons[index]['events'][0]["notes"][0].contains("_face_b_") ? _faceB : _faceA);
  //   });
  //   // print(availableSounds);
  //   await _initializeAudioSources();
  //   _resetSequence();
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: currentEventIndex >= events.length && !widget.isFreeStyle,
      child: Stack(
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              if(!(widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty) && !widget.isFreeStyle) return;
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
              if(!(widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty) && !widget.isFreeStyle) return;
              // Clean up when pointer is released
              _pointerToPadIndex.remove(event.pointer);
              _pointerToSound.remove(event.pointer);
              _lastPointerPositions.remove(event.pointer);
            },
            onPointerMove: (event) async {
              if(!(widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty) && !widget.isFreeStyle) return;
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
              padding: const EdgeInsets.all(16.0),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              physics: NeverScrollableScrollPhysics(),
              itemCount: 12,
              itemBuilder: (context, index) {
                final bool hasSound = index < lessonSounds.length && widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty && !isLoading;
                final String soundId = hasSound && lessonSounds.length == 12 ? lessonSounds[index] : '';
                final bool isHighlighted = highlightedSounds.contains(soundId);
                final sound = lessonSounds.length == 12 ? lessonSounds[index] : '';
                bool isActive = _padPressedIndex.isNotEmpty && _padPressedIndex.contains(index) && ((widget.currentSong != null && widget.currentSong!.lessons.isNotEmpty) || widget.isFreeStyle);
                return RepaintBoundary(
                  key: ValueKey(soundId),
                  child: DrumPadItem(
                    colors: getPadColor(isHighlighted, hasSound, isActive, soundId),
                    sound: sound,
                    theme: currentTheme,
                    isHighlighted: isHighlighted,
                    isActive: isActive,
                    onTap: () => _onPadPressed(sound, index),
                    isPracticeMode: widget.practiceMode == 'practice',
                    isFromBeatRunner: _isFromBeatRunner,
                    shouldShowCircleProgress: (_futureNotes.isNotEmpty
                      && (_futureNotes[0]["notes"] as List).contains(sound)
                      && currentEventIndex != 0
                      && !padProgress.containsKey(sound)
                      && !sound.contains("drum")
                      && _futureNotes[0]["index"] - currentEventIndex < 4
                    ),
                    circleProgressValue: _futureNotes.isNotEmpty ? _calculateProgressValue(currentEventIndex, _futureNotes[0]["index"]) : 0,
                    hasSound: hasSound,
                    padState: padStates[sound],
                    shouldShowSquareProgress: padProgress.containsKey(sound),
                    squareProgressValue: padProgress[sound] ?? 0,
                    shouldShowColorAnimation: (_colorAnimations.containsKey(index) &&
                      _colorAnimations[index] != null &&
                      _colorControllers[index] != null &&
                      _colorControllers[index]!.isAnimating),
                    colorAnimation: _colorAnimations[index] ?? AlwaysStoppedAnimation<Color>(Colors.transparent),
                  ),
                );
              },
            )
          ),
          
          // Positioned(child: Text("isLoading: $isLoading, current song: ${widget.currentSong?.name}")),
          if(isLoading && widget.currentSong != null && widget.isFreeStyle)
            Positioned.fill(child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withValues(alpha: 0.5),
              ),
              child: Center(
                child: SizedBox(
                  width: 100, height: 100,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 10,)
                )
              )
            )
          ),
        ],
      ),
    );
  }

}