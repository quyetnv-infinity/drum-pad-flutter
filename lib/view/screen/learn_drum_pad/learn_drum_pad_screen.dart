import 'dart:ui';

import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/font_responsive.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/song_score_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/drum_pad/drum_pad_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/campaign_provider.dart';
import 'package:and_drum_pad_flutter/view_model/drum_learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class LearnDrumPadScreen extends StatefulWidget {
  final SongCollection songCollection;
  final int lessonIndex;
  const LearnDrumPadScreen({super.key, required this.songCollection, required this.lessonIndex});

  @override
  State<LearnDrumPadScreen> createState() => _LearnDrumPadScreenState();
}

class _LearnDrumPadScreenState extends State<LearnDrumPadScreen> {
  final GlobalKey _widgetPadKey = GlobalKey();
  int _currentScore = 0;
  double _percentStar = 0;
  bool _isRecordingSelected = false;
  bool _isPlaying = false;
  int _perfectPoint = 0;
  final GlobalKey _topViewLearn = GlobalKey();
  final GlobalKey _songNameLearn = GlobalKey();
  bool isShowTutorial = false;
  late Size _padSize;
  late Size _topViewSize;
  late Function() _pauseHandler;

  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureWidgets();
      _initTutorial();
    });
  }

  void _measureWidgets() {
    final box1 = _widgetPadKey.currentContext?.findRenderObject() as RenderBox?;
    final box2 = _topViewLearn.currentContext?.findRenderObject() as RenderBox?;

    if (box1 != null && box2 != null) {
      _padSize = box1.size;
      _topViewSize = box2.size;
    }
    print(MediaQuery.sizeOf(context).height - (_padSize.height + _topViewSize.height));
    print('MediaQuery.sizeOf(context).height - (_padSize.height + _topViewSize.height)');
  }

  void _initTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      opacityShadow: 0.8,
      hideSkip: true,
      onClickOverlay: (p0) {
        tutorialCoachMark.next();
      },
      onFinish: () {
        // _startHandler();
      },
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
        identify: "pad_widget_learn",

        keyTarget: _widgetPadKey,
        shape: ShapeLightFocus.RRect,
        radius: 20,
        contents: [
          TargetContent(
              padding: EdgeInsets.symmetric(horizontal: 16),
              align: ContentAlign.top,
              child: Transform.translate(
                offset: Offset(0, 20),
                child: Container(
                  // height: MediaQuery.sizeOf(context).height - (_padSize.height + _topViewSize.height) ,
                  padding: EdgeInsets.only(bottom:MediaQuery.sizeOf(context).height - (_padSize.height + 96)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButtonCustom(iconAsset: ResIcon.icClose, onTap: () {
                        tutorialCoachMark.finish();
                      },),
                      _buildTutorialStep(title: '1/3')
                    ],
                  ),
                ),
              )
          ),
          TargetContent(
              align: ContentAlign.top,
              // padding: EdgeInsets.all(0),
              child: Transform.translate(
                offset: Offset(0, _topViewSize.height * 0.6),
                child: SizedBox(
                  height: _topViewSize.height * 0.6,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SvgPicture.asset(ResIcon.icTuto1),
                      Transform.translate(
                          offset: Offset(0, -_topViewSize.height * 0.1),
                          child: _buildTutorialStep(
                              title: context.locale.drum_pad_area, fontSize: FontResponsive.responsiveFontSize(_topViewSize.width, 20)))
                    ],
                  ),
                ),
              )
          )
        ],
      ),
      TargetFocus(
        identify: "top_view_learn",
        keyTarget: _topViewLearn,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 20,
        contents: [
          TargetContent(
              padding: EdgeInsets.symmetric(horizontal: 16),
              align: ContentAlign.top,
              child: Transform.translate(
                offset: Offset(0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButtonCustom(iconAsset: ResIcon.icClose, onTap: () {
                      tutorialCoachMark.finish();
                    },),
                    _buildTutorialStep(title: '2/3')
                  ],
                ),
              )
          ),
          TargetContent(
              align: ContentAlign.bottom,
              // padding: EdgeInsets.all(0),
              child: Transform.translate(
                offset: Offset(0, _topViewSize.height * 0.1),
                child: SizedBox(
                  height: _topViewSize.height * 0.6,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Transform.translate(
                        offset: Offset(0, -_topViewSize.height * 0.2),
                        child: Transform.flip(
                          flipX: true,
                          child: Transform.rotate(
                              angle: 135,
                              child: SvgPicture.asset(ResIcon.icTuto1)),
                        ),
                      ),
                      _buildTutorialStep(
                          title: context.locale.drum_pad_area, fontSize: FontResponsive.responsiveFontSize(_topViewSize.width, 20))
                    ],
                  ),
                ),
              )
          )
        ],
      ),
      TargetFocus(
        identify: "song_name_learn",
        keyTarget: _songNameLearn,
        shape: ShapeLightFocus.RRect,
        radius: 20,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Transform.translate(
                offset: Offset(0, -60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButtonCustom(iconAsset: ResIcon.icClose, onTap: () {

                    },),

                    _buildTutorialStep(title: '3/3')
                  ],
                ),
              )
          ),
          TargetContent(
              align: ContentAlign.bottom,
              child: Transform.translate(
                offset: Offset(40,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SvgPicture.asset(ResIcon.icTuto2),
                    Transform.translate(
                        offset: Offset(0,-10),
                        child: _buildTutorialStep(
                            title: context.locale.tap_here_to_change_song, fontSize: FontResponsive.responsiveFontSize(_topViewSize.width, 20)))
                  ],
                ),
              )
          )
        ],
      ),
    ];
  }

  void showTutorial() {
    print('object');
    tutorialCoachMark.show(context: context);
    print('object');
  }
  Future<void> updateUnlockedLesson() async {
    final drumLearnProvider = Provider.of<DrumLearnProvider>(context, listen: false);
    final campaignProvider = Provider.of<CampaignProvider>(context, listen: false);
    List<LessonSequence> updatedLessons = (await drumLearnProvider.getSong(widget.songCollection.id))!.lessons;

    final indexUpdated = campaignProvider.currentLessonCampaign;
    print('unlocked $indexUpdated');
    if (indexUpdated < updatedLessons.length) {
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
    print('update star $star at ${campaignProvider.currentLessonCampaign}');
    final newSong = widget.songCollection.copyWith(lessons: updatedLessons);
    await provider.updateSong(widget.songCollection.id, newSong);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AppScaffold(
        appBar: CustomAppBar(
          iconLeading: ResIcon.icBack,
          onTapLeading: () {
            Navigator.pop(context);
          },
          titleWidget: _buildTitle(),
          action: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButtonCustom(
                iconAsset: ResIcon.icRecord,
                onTap:() {

                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButtonCustom(
                iconAsset: ResIcon.icTutorial,
                onTap:() {
                  _pauseHandler();
                  showTutorial();
                  setState(() {
                    isShowTutorial = true;
                  });
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SongScoreWidget(key: _topViewLearn, songCollection: widget.songCollection, starPercent: _percentStar, score: _currentScore, perfectPoint: _perfectPoint,),
                ),
              ),
              DrumPadScreen(
                key: _widgetPadKey,
                lessonIndex: widget.lessonIndex,
                currentSong: widget.songCollection,
                onRegisterPauseHandler: (pauseHandler) {
                  _pauseHandler = pauseHandler;
                },
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
                onChangePerfectPoint: (perfectPoint) {
                  setState(() {
                    _perfectPoint = perfectPoint;
                  });
                  if(_perfectPoint == 0){
                    print('perfectPoint =00000000');
                  }
                  print(perfectPoint);
                  print('perfectPoint');
                },
                onChangeUnlockedModeCampaign: () async {
                  await updateUnlockedLesson();
                },
                onChangeCampaignStar: (star) async {
                  await updateLessonStar(star);
                },
                isFromLearnScreen: true,
                isFromCampaign: false,
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
      ),
    );
  }

  Widget _buildTitle(){
    return Container(
      key: _songNameLearn,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Row(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(ResIcon.icWaveForm),
          Flexible(child: Text("${widget.songCollection.name} - ${widget.songCollection.author}", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16),))
        ],
      ),
    );
  }
  Widget _buildTutorialStep({required String title, double? fontSize} ){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: fontSize ?? 14),),
    );
  }
}
