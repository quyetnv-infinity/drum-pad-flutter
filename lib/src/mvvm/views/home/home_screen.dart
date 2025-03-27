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

  final List<SongCollection> _data = [
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Recommend", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
            ),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_data.length, (index) {
                  SongCollection item = _data[index];
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 16 : 0, right: index == _data.length - 1 ? 16 : 12),
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
                        Text("${item.name}", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                        Text("${item.author}", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  );
                },),
              ),
            )
          ],
        ),
      ),
    );
  }
}
