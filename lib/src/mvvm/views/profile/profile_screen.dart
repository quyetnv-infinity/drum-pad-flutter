import 'package:drumpad_flutter/core/res/style/text_style.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/home/widgets/horizontal_list.dart';
import 'package:drumpad_flutter/src/mvvm/views/lessons/lessons_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/loading_data/loading_data_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/profile/widget/carousel_widget.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<SongCollection> randomSongs = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    List<SongCollection> songs = await context.read<DrumLearnProvider>().getRandomSongs();
    setState(() {
      randomSongs = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundType: BackgroundType.gradient,
      backgroundFit: BoxFit.cover,
      appBar: AppBar(
          leadingWidth: 100,
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                Text(context.locale.back, style: TextStyle(color: Colors.white, fontSize: 17),)
              ],
            ),
          ),
        ),
        title: Text(
          context.locale.your_profile,
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        )
      ),
      body: SafeArea(
        child: Column(
          children: [
            CarouselWidget(),
            Spacer(),
            Column(
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
                  data: randomSongs,
                  onTap: (item, index) {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => LoadingDataScreen(
                      song: item,
                      callbackLoadingFailed: (){
                        Navigator.pop(context);
                      },
                      callbackLoadingCompleted: (song) {
                        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LessonsScreen(songCollection: song,),));
                      },
                    ),));
                  },
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}
