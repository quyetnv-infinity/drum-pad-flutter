import 'dart:async';
import 'dart:ui';

import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/core/utils/pad_util.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/tutorial_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/learn_from_song_screen.dart';
import 'package:drumpad_flutter/src/widgets/drum_pad/drum_pad_widget.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class BeatRunnerScreen extends StatefulWidget {
  const BeatRunnerScreen({super.key,});

  @override
  State<BeatRunnerScreen> createState() => _BeatRunnerScreenState();
}

class _BeatRunnerScreenState extends State<BeatRunnerScreen> with SingleTickerProviderStateMixin {
  final GlobalKey _widgetPadKey = GlobalKey();

  SongCollection? _currentSong;
  int _currentScore = 0;
  late TutorialCoachMark tutorialCoachMark;
  final GlobalKey _chooseSongKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Initialize tutorial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initTutorial();
      final tutorialProvider = Provider.of<TutorialProvider>(context, listen: false);
      final isFirstTimeShowTutorial = tutorialProvider.isFirstTimeShowTutorial;
      if(isFirstTimeShowTutorial && _currentSong == null){
        Future.delayed(Duration(milliseconds: 500), () {
          showTutorial();
          tutorialProvider.setFirstShowTutorial();
        },);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      opacityShadow: 0.8,
      hideSkip: true,
      onClickTarget: (_) {
        print('target');
        tutorialCoachMark.next();
      },
      onClickOverlay: (_) {
        print('overlay');
        tutorialCoachMark.next();
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
    ];
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: topView()
            ),
            DrumPadScreen(
              key: _widgetPadKey,
              currentSong: _currentSong, onChangeScore: (int score) {
                setState(() {
                  _currentScore = score;
                });
            },
            )
          ],
        ),
      ),
    );
  }

  List<Color> getPadColor(bool isHighlighted, bool hasSound, bool isActive, String soundId){
    if(_currentSong == null) return [Color(0xFF919191), Color(0xFF5E5E5E)];
    return isHighlighted ? [Color(0xFFEDC78C), Colors.orange] : (hasSound ? PadUtil.getPadGradientColor(isActive, soundId) : [Color(0xFF919191), Color(0xFF5E5E5E)]);
  }

  Widget topView(){
    return Container(
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
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                        Text(context.locale.back, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),)
                      ],
                    ),
                  ),

                  if(_currentSong == null) InkWell(
                    onTap: (){
                      showTutorial();
                    },
                    child: Text(context.locale.tutorial, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14, decoration: TextDecoration.underline),)
                  )
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      key: _chooseSongKey,
                      child: GestureDetector(
                        onTap: (){
                          onTapChooseSong();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFF4E4371)
                          ),
                          alignment: Alignment.center,
                          child: _currentSong == null ?
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15)
                            ),
                            child: Icon(Icons.add, color: Colors.white, size: 40,),
                          )
                          :
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(_currentSong!.image!, fit: BoxFit.cover, width: double.infinity, height: double.infinity,)
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(context.locale.score, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),),
                        Text(_currentScore.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: Colors.white),)
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onTapChooseSong() async {
    print('onTap chooseSound');
    final result = await Navigator.push(context, CupertinoPageRoute(builder: (context) => LearnFromSongScreen(isChooseSong: true,),));
    if(result != null) {
      setState(() {
        _currentSong = result;
      });
      print(_currentSong?.name);
    }
  }
}
