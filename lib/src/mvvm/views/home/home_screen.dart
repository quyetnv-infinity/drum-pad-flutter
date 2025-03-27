import 'dart:ui';

import 'package:drumpad_flutter/core/res/dimen/spacing.dart';
import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/res/style/text_style.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/views/setting/setting_screen.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<SongCollection> _data = [
    SongCollection(
        lessons: [],
        image: "assets/images/music_99%.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
  ];

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
              Navigator.push(context, CupertinoPageRoute(builder: (context) => SettingScreen(),));
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  _data.length,
                  (index) {
                    SongCollection item = _data[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          left: index == 0 ? 16 : 0,
                          right: index == _data.length - 1 ? 16 : 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(item.image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "${item.name}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${item.author}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            _buttonAction(
              title: context.locale.beat_runner,
              content: context.locale.sub_button_beat_runner,
              imageBackground: ResImage.imgBgButtonBeatRunner,
              onPress: () {},
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  _data.length,
                  (index) {
                    SongCollection item = _data[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          left: index == 0 ? 16 : 0,
                          right: index == _data.length - 1 ? 16 : 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 180,
                            height: 240,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(item.image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "${item.name}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${item.author}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            _buttonAction(
              title: context.locale.drum_learn,
              content: context.locale.sub_button_drum_learn,
              imageBackground: ResImage.imgBgButtonBeatRunner,
              onPress: () {},
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  _data.length,
                  (index) {
                    SongCollection item = _data[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          left: index == 0 ? 16 : 0,
                          right: index == _data.length - 1 ? 16 : 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 180,
                            height: 240,
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(item.image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.5),
                                      // Background với overlay effect
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x30000000),
                                          blurRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      item.difficulty.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.5),
                                            blurRadius: 2,
                                          ),
                                        ],
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "${item.name}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${item.author}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonAction(
      {required String title,
      required String content,
      required String imageBackground,
      required Function() onPress}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imageBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ResSpacing.h12,
                Text(
                  content,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(ResIcon.icArrowLeftCircleSolid),
        ],
      ),
    );
  }
}
