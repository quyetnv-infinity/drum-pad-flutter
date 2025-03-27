import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/style/text_style.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<SongCollection> _data = [
    SongCollection(lessons: [], image: "assets/images/lactroi.png", author: "Sơn Tùng M-TP", name: "Lạc Trôi"),
    SongCollection(lessons: [], image: "assets/images/lactroi.png", author: "Sơn Tùng M-TP", name: "Lạc Trôi"),
    SongCollection(lessons: [], image: "assets/images/lactroi.png", author: "Sơn Tùng M-TP", name: "Lạc Trôi"),
    SongCollection(lessons: [], image: "assets/images/lactroi.png", author: "Sơn Tùng M-TP", name: "Lạc Trôi"),
    SongCollection(lessons: [], image: "assets/images/lactroi.png", author: "Sơn Tùng M-TP", name: "Lạc Trôi"),
    SongCollection(lessons: [], image: "assets/images/lactroi.png", author: "Sơn Tùng M-TP", name: "Lạc Trôi"),
    SongCollection(lessons: [], image: "assets/images/lactroi.png", author: "Sơn Tùng M-TP", name: "Lạc Trôi"),
    SongCollection(lessons: [], image: "assets/images/lactroi.png", author: "Sơn Tùng M-TP", name: "Lạc Trôi"),
    SongCollection(lessons: [], image: "assets/images/lactroi.png", author: "Sơn Tùng M-TP", name: "Lạc Trôi"),
    SongCollection(lessons: [], image: "assets/images/lactroi.png", author: "Sơn Tùng M-TP", name: "Lạc Trôi"),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundType: BackgroundType.gradient,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "DRUMPAD",
          style: TextStyle(
            fontFamily: AppFonts.ethnocentric,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(ResIcon.icSettingOutline),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Text("Recommend", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),

          ],
        ),
      ),
    );
  }
}
