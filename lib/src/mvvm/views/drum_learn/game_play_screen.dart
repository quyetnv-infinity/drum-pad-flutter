import 'dart:async';
import 'dart:ui';

import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/core/utils/pad_util.dart';
import 'package:drumpad_flutter/core/utils/permission_util.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/campaign_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/tutorial_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/mode_btn/mode_button.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/tutorial_blur_widget.dart';
import 'package:drumpad_flutter/src/service/screen_record_service.dart';
import 'package:drumpad_flutter/src/widgets/anim/text_animation.dart';
import 'package:drumpad_flutter/src/widgets/blur_widget.dart';
import 'package:drumpad_flutter/src/widgets/drum_pad/drum_pad_widget.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:drumpad_flutter/src/widgets/star/star_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class GamePlayScreen extends StatefulWidget {
  final SongCollection songCollection;
  final int index;
  final bool isFromCampaign;
  final void Function()? onChangeUnlockedModeCampaign;
  final void Function(double star)? onChangeCampaignStar;
  const GamePlayScreen({super.key, required this.songCollection, required this.index, this.isFromCampaign = false, this.onChangeUnlockedModeCampaign, this.onChangeCampaignStar});

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
  bool isRecording = false;
  double _percentStar = 0;
  bool _isRecordingSelected = false;
  bool _isPlaying = false;

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
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0),
                        child: Icon(Icons.arrow_upward, color: Colors.white, size: 28,),
                      ),
                      SizedBox(height: 12),
                      Text(
                        context.locale.your_song_appear_here,
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
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Spacer(),
                          Column(
                            spacing: 10,
                            children: [
                              Icon(Icons.arrow_upward, color: Colors.white, size: 28,),
                              Text(
                                context.locale.practice,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            spacing: 10,
                            children: [
                              Icon(Icons.arrow_upward, color: Colors.white, size: 28,),
                              Text(
                                context.locale.rec,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          )
                          // Text(
                          //   context.locale.change_mode,
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 17,
                          //       fontWeight: FontWeight.w500
                          //   ),
                          // ),
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
    final campaignProvider = Provider.of<CampaignProvider>(context, listen: false);
    List<LessonSequence> updatedLessons = (await drumLearnProvider.getSong(widget.songCollection.id))!.lessons;

    final indexUpdated = campaignProvider.currentLessonCampaign + 1;
    if (indexUpdated > 0 && indexUpdated < updatedLessons.length) {
      updatedLessons[indexUpdated].isCompleted = true;
    }

    final newSong = widget.songCollection.copyWith(lessons: updatedLessons);
    await drumLearnProvider.updateSong(widget.songCollection.id, newSong);
  }

  Future<void> updateLessonStar(double star) async {
    final provider = Provider.of<DrumLearnProvider>(context, listen: false);
    final campaignProvider = Provider.of<CampaignProvider>(context, listen: false);
    List<LessonSequence> updatedLessons = (await provider.getSong(widget.songCollection.id))!.lessons;
    updatedLessons[campaignProvider.currentLessonCampaign].star = star;
    final newSong = widget.songCollection.copyWith(lessons: updatedLessons);
    await provider.updateSong(widget.songCollection.id, newSong);
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
                    onChangeScore: (int score, ) {
                      setState(() {
                        _currentScore = score;
                      });
                    },
                    onChangeStarLearn: (star) {
                      setState(() {
                        _percentStar = star ;
                        print(star);
                      });
                    },
                    onChangeUnlockedModeCampaign: () async {
                      if(widget.isFromCampaign){
                        widget.onChangeUnlockedModeCampaign?.call();
                      } else {
                        await updateUnlockedLesson();
                      }
                    },
                    onChangeCampaignStar: (star) async {
                      if(widget.isFromCampaign){
                        widget.onChangeCampaignStar?.call(star);
                      } else {
                        await updateLessonStar(star);
                      }
                    },
                    isFromLearnScreen: !widget.isFromCampaign,
                    isFromCampaign: widget.isFromCampaign,
                    onResetRecordingToggle: () {
                      setState(() {
                        _isRecordingSelected = false;
                      });
                    },
                    onChangePlayState: (isPlaying) {
                      setState(() {
                        _isPlaying = isPlaying;
                      });
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
          margin: EdgeInsets.only(right: 16, left: 16, bottom: 10, top: 24),
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
                        onTap: ()async {
                          Navigator.pop(context);
                          context.read<DrumLearnProvider>().resetPerfectPoint();
                          if (context.read<DrumLearnProvider>().isRecording) await ScreenRecorderService().stopRecording(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                            Text(context.locale.back, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),)
                          ],
                        ),
                      ),
                      if(!_isPlaying) InkWell(
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
                                    child: BlurWidget(text: widget.songCollection.difficulty.toUpperCase())),
                                  ComboWidget()
                                ],
                              )
                            ),
                          ),
                        ),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(context.locale.progress, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),),
                            // RatingStars.custom(value: _starAnimation.value ,isFlatStar: true, smallStarWidth: 18, smallStarHeight: 18, bigStarWidth: 18, bigStarHeight: 18,),
                            RatingStars.custom(
                              value: _percentStar,
                              isFlatStar: true,
                              smallStarWidth: 18,
                              smallStarHeight: 18,
                              bigStarWidth: 18,
                              bigStarHeight: 18,
                            ),
                            Text(context.locale.score, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),),
                            // Text(_currentScore.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: Colors.white),),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 1.0,
                                end: 1.0 + (context.watch<DrumLearnProvider>().perfectPoint.clamp(0, 8) * 0.05),
                              ),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.elasticOut,
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: child,
                                );
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 150),
                                switchInCurve: Curves.fastEaseInToSlowEaseOut,
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: Text(
                                  _currentScore.toString(),
                                  key: ValueKey<int>(_currentScore),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 32,
                                    color: Colors.white,
                                  ),
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
        // Center(
        //     child: ComboText())
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
          // ModeButton(title: context.locale.mode, initialSelected: false, onSelected: (bool selected) {},),
          ModeButton(title: context.locale.practice, initialSelected: false, onSelected: (bool selected) {
            selected ? _updateSelectedMode("practice") : _updateSelectedMode("null");
          },),
          ModeButton(title: context.locale.rec, initialSelected: _isRecordingSelected, onSelected: (bool selected) async {
            setState(() {
              _isRecordingSelected = selected;
            });
            if (selected) {
              await handleOnTogglePhotosAddOnlyPermission();
              if(!await Permission.photosAddOnly.status.isGranted){
                setState(() {
                  _isRecordingSelected = false;
                });
                return;
              }

              await ScreenRecorderService().startRecording(context, () {
                setState(() {
                  _isRecordingSelected = false;
                });
              },);
              if(!_isRecordingSelected) return;
              context.read<DrumLearnProvider>().updateRecording();
              print("ModeButton selected: true - Attempting to start recording...");
            } else {
              print("ModeButton selected: false - Attempting to stop recording...");
              await ScreenRecorderService().stopRecording(context);
              context.read<DrumLearnProvider>().updateRecording();
            }
          },
          ),
        ],
      ),
    );
  }
  Future<void> handleOnTogglePhotosAddOnlyPermission() async {
    final permissionStatus = await Permission.photos.status;
    print(permissionStatus);
    if (!permissionStatus.isGranted) {
      await Permission.photos.request();
      if(await Permission.photos.status.isPermanentlyDenied || await Permission.photos.status.isDenied ){
        if(!mounted) return;
        PermissionUtil.showRequestPhotosPermissionDialog(context);
        return;
      } else if (await Permission.photos.status.isGranted){
        return;
      }
    }
  }
}