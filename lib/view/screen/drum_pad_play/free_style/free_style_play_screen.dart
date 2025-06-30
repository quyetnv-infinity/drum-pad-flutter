import 'dart:ui';

import 'package:and_drum_pad_flutter/core/res/dimen/spacing.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/font_responsive.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/add_new_song.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/pick_song_bottom_sheet.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/drum_pad/drum_pad_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/tutorial_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class FreeStylePlayScreen extends StatefulWidget {
  const FreeStylePlayScreen({super.key});

  @override
  State<FreeStylePlayScreen> createState() => _FreeStylePlayScreenState();
}

class _FreeStylePlayScreenState extends State<FreeStylePlayScreen> with SingleTickerProviderStateMixin {
  final GlobalKey _widgetFreePadKey = GlobalKey();
  final GlobalKey _topViewFreePad = GlobalKey();
  SongCollection? _songCollection;
  late Size _padSize;
  late Size _topViewSize;

  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        _measureWidgets();
        _initTutorial();
      },);
      final tutorialProvider = Provider.of<TutorialProvider>(context, listen: false);
      final isFirstTimeShowTutorial = tutorialProvider.isFirstTimeShowTutorial;
      if(isFirstTimeShowTutorial){
        Future.delayed(Duration(milliseconds: 200), () {
          showTutorial();
          tutorialProvider.setFirstShowTutorialFree();
        },);
      }
    });
  }
  void _measureWidgets() {
    final box1 = _widgetFreePadKey.currentContext?.findRenderObject() as RenderBox?;
    final box2 = _topViewFreePad.currentContext?.findRenderObject() as RenderBox?;

    if (box1 != null && box2 != null) {
      _padSize = box1.size;
      _topViewSize = box2.size;
    }
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
    );
  }
  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "free_pad_widget",
        keyTarget: _widgetFreePadKey,
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
        identify: "top_view_free_pad",
        keyTarget: _topViewFreePad,
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
    ];
  }

  void showTutorial() {
    print('object');
    tutorialCoachMark.show(context: context);
    print('object');
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(iconLeading: ResIcon.icBack, onTapLeading: () {
        Navigator.pop(context);
      },
        action: [
          if(_songCollection != null)
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
            child: IconButtonCustom(iconAsset: ResIcon.icTutorial, onTap:() {
              showTutorial();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AddNewSong(
                  key: _topViewFreePad,
                  songCollection: _songCollection,
                  onTap: () async {
                    final result = await showModalBottomSheet<SongCollection>(
                      isScrollControlled: true,
                      barrierColor: Colors.black.withValues(alpha: 0.8),
                      context: context,
                      builder: (context) => PickSongScreen(),
                    );
                    if (result != null) {
                      setState(() {
                        _songCollection = result;
                      });
                      print('Selected song: ${result.lessons.length}');
                    }
                  },
                  onTapClearSong: () {
                    print('asdasdsa');
                    setState(() {
                      _songCollection = null;
                    });
                },
              ),
            ),
          ),
          DrumPadScreen(
            key: _widgetFreePadKey,
            lessonIndex: (_songCollection?.lessons.length ?? 0) - 1,
            currentSong: _songCollection,
            practiceMode: 'practice',
            onChangeScore: (int score, ) {

            },
            onChangeStarLearn: (star) {

            },
            onChangeUnlockedModeCampaign: () {
            },
            onChangeCampaignStar: (star) async {

            },
            isFromLearnScreen: true,
            isFromCampaign: false,
            onResetRecordingToggle: () {
              // setState(() {
              //   _isRecordingSelected = false;
              // });
            },
            onChangePlayState: (isPlaying) {
              // setState(() {
              //   _isPlaying = isPlaying;
              // });
            },
          ),

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
