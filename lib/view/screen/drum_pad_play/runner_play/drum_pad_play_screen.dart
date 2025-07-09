import 'dart:ui';

import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/font_responsive.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/add_new_song.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/pick_song_bottom_sheet.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/song_score_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/drum_pad/drum_pad_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/loading_dialog/exit_dialog.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/tutorial_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DrumPadPlayScreen extends StatefulWidget {
  final SongCollection songCollection;
  const DrumPadPlayScreen({super.key, required this.songCollection});

  @override
  State<DrumPadPlayScreen> createState() => _DrumPadPlayScreenState();
}

class _DrumPadPlayScreenState extends State<DrumPadPlayScreen> {
  double _starPercent = 0;
  int _score = 0;
  int _perfectPoint = 0;
  final GlobalKey _padWidget = GlobalKey();
  final GlobalKey _topView = GlobalKey();
  final GlobalKey _songName = GlobalKey();
  bool isShowTutorial = false;
  late Size _padSize;
  late Size _topViewSize;
  late SongCollection _currentSong;

  late TutorialCoachMark tutorialCoachMark;
  late Function() _pauseHandler;
  late Function() _startHandler;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentSong = widget.songCollection;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureWidgets();
      _initTutorial();
      final tutorialProvider = Provider.of<TutorialProvider>(context, listen: false);
      final isFirstTimeShowTutorial = tutorialProvider.isFirstTimeShowTutorialLearn;
      if(isFirstTimeShowTutorial){
        Future.delayed(Duration(milliseconds: 200), () {
          showTutorial();
          tutorialProvider.setFirstShowTutorialLearn();
        },);
      }
    });

  }
  void _measureWidgets() {
    final box1 = _padWidget.currentContext?.findRenderObject() as RenderBox?;
    final box2 = _topView.currentContext?.findRenderObject() as RenderBox?;

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
        identify: "pad_widget",

        keyTarget: _padWidget,
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
        identify: "top_view",
        keyTarget: _topView,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 20,
        contents: [
          // TargetContent(
          //   padding: EdgeInsets.symmetric(horizontal: 16),
          //     align: ContentAlign.top,
          //     child: Transform.translate(
          //       offset: Offset(0, 20),
          //       child: Container(
          //         height: MediaQuery.sizeOf(context).height - _padSize.height ,
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: <Widget>[
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 IconButtonCustom(iconAsset: ResIcon.icClose, onTap: () {
          //
          //                 },),
          //                 _buildTutorialStep(title: '2/3')
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     )
          // ),
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
                        title: context.locale.star_score_display, fontSize: FontResponsive.responsiveFontSize(_topViewSize.width, 20))
                    ],
                  ),
                ),
              )
          )
        ],
      ),
      TargetFocus(
        identify: "song_Name",
        keyTarget: _songName,
        // paddingFocus: -10,
        enableOverlayTab: true,
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
                    print("======= finísh");
                    tutorialCoachMark.finish();
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(iconLeading: ResIcon.icBack, onTapLeading: () {
       _pauseHandler();
        showDialog(context: context, barrierDismissible: true, barrierColor: Colors.black.withValues(alpha: 0.9),
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: ExitDialog(
              onTapCancel: () {
                Navigator.pop(context);

                _startHandler();
              },
              onTapContinue: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          )
        );
        // Navigator.pop(context);
      },
        titleWidget: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            _pauseHandler();
            final result = await showModalBottomSheet<SongCollection>(
              isScrollControlled: true,
              barrierColor: Colors.black.withValues(alpha: 0.8),
              context: context,
              builder: (context) => PickSongScreen(isWithCategory: true, songCollection: _currentSong,),
            );
            if (result != null) {
              setState(() {
                _currentSong = result;
              });
              print('Selected song: ${result.lessons.length}');
            }
          },
          child: _buildTitle()),
        action: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButtonCustom(iconAsset: ResIcon.icTutorial, onTap:() {
              print('ee');
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
      body:  Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SongScoreWidget(key: _topView, songCollection: _currentSong, starPercent: _starPercent, score: _score, perfectPoint: _perfectPoint,),
            ),
          ),
          // Spacer(),
          DrumPadScreen(
            key: _padWidget,
            onRegisterPauseHandler: (pauseHandler) {
              _pauseHandler = pauseHandler;
            },
            onRegisterStartHandler: (startHandler) {
              _startHandler = startHandler;
            },
            onChangePerfectPoint: (perfectPoint) {
              setState(() {
                perfectPoint != 0 ? _perfectPoint += perfectPoint : _perfectPoint = 0;
              });
              if(_perfectPoint == 0){
                print('perfectPoint =00000000');
              }
              print(perfectPoint);
              print('perfectPoint');
            },
            currentSong: _currentSong,
            onChangeStarLearn:(star) {
              setState(() {
                _starPercent = star;
              });
            },
            onChangeScore: (score) {
              setState(() {
                _score = score;
              });
            },
            onTapChooseSong:(song) {
              setState(() {
                _currentSong = song;
              });
            },
            isFromLearnScreen: false,
            isFromCampaign: false
          )
        ],
      ),
    );
  }

  Widget _buildTitle(){
    return Container(
      key: _songName,
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
          Flexible(
            child: SizedBox(
              height: 22,
              child: Marquee(
                text: "${_currentSong.name} - ${_currentSong.author}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 50.0,
                velocity: 30.0,
                startPadding: 10.0,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
          // Flexible(child: Text("${widget.songCollection.name} - ${widget.songCollection.author}", style: TextStyle(fontSize: 16),))
        ],
      ),
    );
  }
  Widget _buildTutorialStep({required String title, double? fontSize} ){
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Text(title, textAlign: TextAlign.center, maxLines: 3, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: fontSize ?? 14),),
    );
  }
}
