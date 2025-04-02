import 'dart:async';
import 'dart:ui';

import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/core/utils/pad_util.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/tutorial_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/learn_from_song_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/mode_btn/mode_button.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/tutorial_blur_widget.dart';
import 'package:drumpad_flutter/src/widgets/anim/combo_text.dart';
import 'package:drumpad_flutter/src/widgets/anim/text_animation.dart';
import 'package:drumpad_flutter/src/widgets/blur_widget.dart';
import 'package:drumpad_flutter/src/widgets/drum_pad/drum_pad_widget.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:drumpad_flutter/src/widgets/star/star_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class GamePlayScreen extends StatefulWidget {
  final SongCollection songCollection;
  final int index;
  const GamePlayScreen({super.key, required this.songCollection, required this.index});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> with SingleTickerProviderStateMixin {
  final GlobalKey _widgetPadKey = GlobalKey();
  bool isShowTutorial = false;

  int _currentScore = 0;
  late TutorialCoachMark tutorialCoachMark;
  final GlobalKey _chooseSongKey = GlobalKey();
  final GlobalKey _changeMode = GlobalKey();
  double padHeight = 100.0;
  String selectedMode = "";
  bool _isRecording = false;
  String? _recordingPath;


  @override
  void initState() {
    super.initState();
    // Initialize tutorial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getWidgetPadSize();
      _initTutorial();
      final tutorialProvider = Provider.of<TutorialProvider>(context, listen: false);
      final isFirstTimeShowTutorial = tutorialProvider.isFirstTimeShowTutorialLearn;
      if(isFirstTimeShowTutorial){
        Future.delayed(Duration(milliseconds: 500), () {
          showTutorial();
          tutorialProvider.setFirstShowTutorialLearn();
        },);
      }
    });
  }
  void _getWidgetPadSize() {
    final RenderBox? renderBox = _widgetPadKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      setState(() {
        padHeight = renderBox.size.height;
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
  }

  void _updateSelectedMode(String mode) {
    setState(() {
      selectedMode = mode;
    });
    print('asdasd $selectedMode');
  }

  void _initTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      opacityShadow: 0.8,
      hideSkip: true,
      onClickTarget: (target) {
        if (target.identify == "change_mode") {
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              isShowTutorial = true;
            });
          },);
        }
      },
    );
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "choose_song_button",
        keyTarget: _chooseSongKey,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return InkWell(
                onTap: () {
                  tutorialCoachMark.next();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.4),
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 48.0),
                        child: Icon(Icons.arrow_upward, color: Colors.white, size: 28,),
                      ),
                      SizedBox(height: 12),
                      Text(
                        context.locale.select_your_song,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "change_mode",
        keyTarget: _changeMode,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return InkWell(
                onTap: () {
                 tutorialCoachMark.next();
                 Future.delayed(Duration(milliseconds: 500), () {
                   setState(() {
                     isShowTutorial = true;
                   });
                 },);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.4),
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_upward, color: Colors.white, size: 28,),
                          SizedBox(height: 12),
                          Text(
                            context.locale.change_mode,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ];
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  Future<void> updateUnlockedLesson() async {
    final drumLearnProvider = Provider.of<DrumLearnProvider>(context, listen: false);
    List<LessonSequence> updatedLessons = (await drumLearnProvider.getSong(widget.songCollection.id)).lessons;

    final indexUpdated = widget.index + 1;
    if (indexUpdated > 0 && indexUpdated < updatedLessons.length) {
      updatedLessons[indexUpdated].isCompleted = true;
    }

    final newSong = widget.songCollection.copyWith(lessons: updatedLessons);
    await drumLearnProvider.updateSong(widget.songCollection.id, newSong);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CustomScaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: topView()
                  ),
                  DrumPadScreen(
                    key: _widgetPadKey,
                    lessonIndex: widget.index,
                    currentSong: widget.songCollection,
                    practiceMode: selectedMode,
                    onChangeScore: (int score) {
                      setState(() {
                        _currentScore = score ;
                      });
                    },
                    onChangeUnlockedModeCampaign: () async {
                      await updateUnlockedLesson();
                    },
                  )
                ],
              ),
            ),
            if (isShowTutorial)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isShowTutorial = false;
                  });
                },
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 2000),
                  opacity: isShowTutorial ? 1.0 : 0.0,
                  child: TutorialBlurWidget(padHeight: padHeight),
                ),
              ),
            ],
          ),
        ),
    );
  }

  List<Color> getPadColor(bool isHighlighted, bool hasSound, bool isActive, String soundId){
    return isHighlighted ? [Color(0xFFEDC78C), Colors.orange] : (hasSound ? PadUtil.getPadGradientColor(isActive, soundId) : [Color(0xFF919191), Color(0xFF5E5E5E)]);
  }

  Widget topView(){
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.only(right: 16, left: 16, bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xFF382B5E),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          context.read<DrumLearnProvider>().resetPerfectPoint();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                            Text(context.locale.back, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),)
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          showTutorial();
                        },
                        child: Row(
                          spacing: 6,
                          children: [
                            Text(context.locale.instruction, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14, decoration: TextDecoration.underline),),
                            Icon(CupertinoIcons.refresh_bold, size: 18)
                          ],
                        )
                      )
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          key: _chooseSongKey,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFF4E4371)
                            ),
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  Image.asset(widget.songCollection.image!, fit: BoxFit.cover, width: double.infinity, height: double.infinity,),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: BlurWidget(text: widget.songCollection.difficulty)),
                                  ComboWidget()
                                ],
                              )
                            ),
                          ),
                        ),
                        Column(
                          // spacing: 8,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(context.locale.progress, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),),
                            RatingStars.custom(value: 15,isFlatStar: true, smallStarWidth: 18, smallStarHeight: 18, bigStarWidth: 18, bigStarHeight: 18,),
                            Text(context.locale.score, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),),
                            // Text(_currentScore.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: Colors.white),),
                            AnimatedSwitcher(
                              switchInCurve: Curves.fastEaseInToSlowEaseOut,
                              duration: const Duration(milliseconds: 100),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return ScaleTransition(scale: animation, child: child);
                              },
                              child: Text(
                                _currentScore.toString(),
                                key: ValueKey<int>(_currentScore),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            buildModeButton()
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Center(
            child: ComboText())
      ],
    );
  }

  Widget buildModeButton(){
    return Padding(
      key: _changeMode,
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        spacing: 6,
        children: [
          ModeButton(title: context.locale.mode, initialSelected: false, onSelected: (bool selected) {},),
          ModeButton(title: context.locale.practice, initialSelected: false, onSelected: (bool selected) {
            selected ? _updateSelectedMode("practice") : _updateSelectedMode("null");
          },),
          ModeButton(title: context.locale.rec, initialSelected: false, onSelected: (bool selected) async{
            if (selected) {
              // If button is selected (toggled ON), start recording
              print("ModeButton selected: true - Attempting to start recording...");
              await _startRecording();
            } else {
              // If button is deselected (toggled OFF), stop recording
              print("ModeButton selected: false - Attempting to stop recording...");
              await _stopRecording();
            }
          },),
        ],
      ),
    );
  }
  Future<void> _startRecording() async {
    // --- Add Permission Checks ---
    var micStatus = await Permission.microphone.status;
    var photosStatus = await Permission.photos.status; // Or Permission.storage on older Android

    print("[Permissions] Microphone status: $micStatus");
    print("[Permissions] Photos status: $photosStatus");

    bool permissionsGranted = true;
    if (!micStatus.isGranted) {
      print("Microphone permission not granted. Requesting...");
      micStatus = await Permission.microphone.request();
      if (!micStatus.isGranted) permissionsGranted = false;
    }
    // Photos permission is often needed for saving, check if needed before starting
    if (!photosStatus.isGranted && !photosStatus.isLimited) { // isLimited is iOS specific
      print("Photos permission not granted. Requesting...");
      photosStatus = await Permission.photos.request();
      if (!photosStatus.isGranted && !photosStatus.isLimited) permissionsGranted = false;
    }

    if (!permissionsGranted) {
      print("Required permissions were not granted. Cannot start recording.");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please grant Microphone and Photos permissions in Settings.'))
      );
      setState(() { _isRecording = false; }); // Ensure state reflects failure
      return; // Exit the function
    }
    // --- End of Permission Checks ---


    // --- Original Start Logic ---
    try {
      print("Attempting to start recording via native plugin...");
      bool started = await FlutterScreenRecording.startRecordScreenAndAudio(
        "my_recordinggh", // Consider making filename dynamic
        titleNotification: "Screen Recording Title", // Android specific? Check docs
        messageNotification: "Recording in progress...", // Android specific? Check docs
      );
      print("Native plugin startRecordScreenAndAudio returned: $started");

      if (started) {
        setState(() {
          _isRecording = true;
          _recordingPath = null; // Clear path from previous recordings
        });
        print("Screen recording started successfully (plugin returned true).");
      } else {
        // This is the case you are hitting
        print("Screen recording failed to start (plugin returned false). Check native logs/permissions.");
        // Ensure state reflects failure
        setState(() { _isRecording = false; });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to start recording. Did you allow it in the system prompt?'))
        );
      }
    } catch (e) {
      print("Error starting screen recording: $e");
      setState(() { _isRecording = false; }); // Ensure state reflects failure
    }
  }


  Future<void> _stopRecording() async {
    if (!_isRecording) return; // Don't try to stop if not recording

    try {
      // Stop recording and get the file path
      String? path = await FlutterScreenRecording.stopRecordScreen;

      setState(() {
        _isRecording = false;
        _recordingPath = path;
      });

      if (path != null) {
        print("Screen recording stopped successfully. File saved at: $path");
        // You can now use the path, e.g., display the video, upload it, etc.
        _showSuccessDialog(path);
      } else {
        print("Screen recording stopped but path is null.");
        // Handle cases where stopping might not return a path as expected
      }
    } catch (e) {
      print("Error stopping screen recording: $e");
      // Handle potential errors
    }
  }
  void _showSuccessDialog(String path) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Recording Saved"),
        content: Text("Video saved successfully!\nPath: $path"),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}