import 'dart:async';
import 'dart:ui';

import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/core/utils/pad_util.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/tutorial_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/learn_from_song_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/tutorial_blur_widget.dart';
import 'package:drumpad_flutter/src/widgets/blur_widget.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:drumpad_flutter/src/widgets/star/star_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class GamePlayScreen extends StatefulWidget {
  final SongCollection? songCollection;
  const GamePlayScreen({super.key, this.songCollection});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> with SingleTickerProviderStateMixin {
  final GlobalKey _widgetPadKey = GlobalKey();
  late AnimationController _controller;
  bool isPlaying = false;
  bool isShowTutorial = false;

  Set<int> _padPressedIndex = {};

  List<String> lessonSounds = ['unity_mid36_face_a_lead_lead1_a', 'unity_mid37_face_a_lead_lead2_a', 'unity_mid38_face_a_lead_lead3_a', 'unity_mid39_face_a_bass_bass3_a', 'unity_mid40_face_a_bass_bass4_a', 'unity_mid41_face_a_lead_lead4_a', 'unity_mid42_face_a_bass_bass1_a', 'unity_mid43_face_a_bass_bass2_a', 'unity_mid44_face_a_fx_drop_a', 'unity_mid45_face_a_drums_kick', 'unity_mid46_face_a_drums_hihat', 'unity_mid47_face_a_drums_snare'];
  Set<String> highlightedSounds = {};
  SongCollection? _currentSong;
  int _currentScore = 0;
  late TutorialCoachMark tutorialCoachMark;
  final GlobalKey _chooseSongKey = GlobalKey();
  final GlobalKey _changeMode = GlobalKey();
  double padHeight = 100.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150), // Thời gian chạy mặc định
    )..repeat();
    _currentSong = widget.songCollection;

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
    _controller.dispose();
    super.dispose();
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

  double _getPositionTop() {
    final RenderBox renderBox = _widgetPadKey.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero); // Lấy vị trí tuyệt đối
    final double top = position.dy;
    final double bottom = top + renderBox.size.height;
    return top;
  }

  void _onPadPressed(String sound, int index) {
    if(!PadUtil.getPadEnable(sound)) return;

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
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: topView()
                ),
                drumPadView()
              ],
            ),
          ),
          if(isShowTutorial)
          GestureDetector(
            onTap: () {
              setState(() {
                isShowTutorial = false;
              });
            },
            child: TutorialBlurWidget(padHeight:  padHeight,)
          ),
        ],
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
                            child: Stack(
                              children: [
                                Image.asset(_currentSong!.image!, fit: BoxFit.cover, width: double.infinity, height: double.infinity,),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: BlurWidget(text: _currentSong!.difficulty))
                              ],
                            )
                          ),
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
                        Text(_currentScore.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: Colors.white),),
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

  Widget buildModeButton(){
    return Padding(
      key: _changeMode,
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        spacing: 6,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            height: 28,
            width: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(ResImage.imgBGMode))),
            child: Text(context.locale.mode,overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            height: 28,
            width: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(ResImage.imgBGMode))),
            child: Text(context.locale.practice,overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            height: 28,
            width: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(ResImage.imgBGMode))),
            child: Text(context.locale.rec,overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),),
          ),

        ],
      ),
    );
  }

  Widget drumPadView(){
    return GridView.builder(
      key: _widgetPadKey,
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
        final bool hasSound = index < lessonSounds.length;
        final String soundId = hasSound ? lessonSounds[index] : '';
        final bool isHighlighted = highlightedSounds.contains(soundId);
        final sound = lessonSounds[index];
        bool isActive = _padPressedIndex.isNotEmpty && _padPressedIndex.contains(index) && _currentSong != null;
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
              if (isActive)
                Lottie.asset('assets/anim/lightning_button.json', fit: BoxFit.cover, controller: _controller)
            ],
          ),
        );
      },
    );
  }
}
