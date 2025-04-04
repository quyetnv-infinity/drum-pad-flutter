import 'dart:ui';

import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/res/style/text_style.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/home/widgets/button_action.dart';
import 'package:drumpad_flutter/src/mvvm/views/home/widgets/horizontal_list.dart';
import 'package:drumpad_flutter/src/mvvm/views/iap/iap_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/lessons/lessons_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/beat_runner/beat_runner_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/drum_learn_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/profile/profile_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/setting/setting_screen.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late List<SongCollection> _data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = context.read<DrumLearnProvider>().data;
  }
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundType: BackgroundType.gradient,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          context.locale.drum_pad.toUpperCase(),
          style: TextStyle(
            fontFamily: AppFonts.ethnocentric,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => IapScreen(),
                ),
              );
            },
            icon: SvgPicture.asset(ResIcon.icIAP),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
            icon: SvgPicture.asset(ResIcon.icProfile),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SettingScreen(),
                ),
              );
            },
            icon: SvgPicture.asset(ResIcon.icSettingOutline),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                context.locale.recommend,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 12),
            HorizontalList(
              width: 120,
              height: 120,
              data: _data,
              onTap: (item, index) {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => LessonsScreen(songCollection: item,),));
              },
            ),
            ButtonAction(
              title: context.locale.beat_runner,
              content: context.locale.sub_button_beat_runner,
              imageBackground: ResImage.imgBgButtonBeatRunner,
              onPressed: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => BeatRunnerScreen(),));
              },
            ),
            HorizontalList(
              width: 180,
              height: 240,
              data: _data,
              onTap: (item, index) {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => BeatRunnerScreen(songCollection: item,),));
              },
            ),
            ButtonAction(
              title: context.locale.drum_learn,
              content: context.locale.sub_button_drum_learn,
              imageBackground: ResImage.imgBgButtonBeatRunner,
              onPressed: () {
                print('heheeh');
                Navigator.push(context, CupertinoPageRoute(builder: (context) => DrumLearnScreen(),));
              },
            ),
            HorizontalList(
              width: 180,
              height: 240,
              data: _data,
              isShowDifficult: true,
              onTap: (item, index) {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => LessonsScreen(songCollection: item,),));
              },
            ),
          ],
        ),
      ),
    );
  }
}
