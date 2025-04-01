import 'dart:convert';

import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/campaign_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/game_play_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/learn_from_song_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/options_widget.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/song_item.dart';
import 'package:drumpad_flutter/src/mvvm/views/lessons/lessons_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ResumeWidget extends StatefulWidget {
  const ResumeWidget({super.key});

  @override
  State<ResumeWidget> createState() => _ResumeWidgetState();
}

class _ResumeWidgetState extends State<ResumeWidget> {
  SongCollection? _song;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchLessonData();
    },);
  }

  void fetchLessonData() async {
    try {
      final String jsonString =
      await rootBundle.loadString('assets/havana_lessons.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      final songCollection = SongCollection.fromJson(jsonData);

      // Bây giờ bạn có thể sử dụng songCollection.lessons để truy cập vào các bài học
      print("Số lượng bài học: ${songCollection.lessons.length}");

      // Ví dụ: in ra số lượng events trong bài học đầu tiên
      if (songCollection.lessons.isNotEmpty) {
        print("Số lượng events trong bài học đầu tiên: ${songCollection.lessons[0].events.length}");
      }

      setState(() {
        _song = SongCollection(lessons: songCollection.lessons, image: "assets/images/lactroi.png",
            author: "Sơn Tùng M-TP",
            name: "Lạc Trôi");
      });
    } catch (e) {
      print('Error loading sequence data from file: $e');
    } finally {
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(context.locale.resume, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),)
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: MediaQuery.sizeOf(context).width * 0.67,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: context.read<DrumLearnProvider>().data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {

              final song = index == 2 ? _song: context.read<DrumLearnProvider>().data[index];
  
            return GestureDetector(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) =>
                  // GamePlayScreen(songCollection: song)'
                  LessonsScreen(songCollection: song,)
                  ));
              },
              child: SongItem(
                height: MediaQuery.sizeOf(context).width * 0.55,
                isFromLearnFromSong: false,
                model: song ?? context.read<DrumLearnProvider>().data[index],
               ),
            );
          },),
        ),
        SizedBox(height: 12),
        OptionsWidget(title: context.locale.learn_from_song, description: context.locale.learn_from_song_des, asset: ResImage.imgLearnFromSong, func: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => LearnFromSongScreen()))),
        SizedBox(height: 12),
        OptionsWidget(title:  context.locale.campaign, description:  context.locale.campaign_des, asset: ResImage.imgCampaign, func: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => CampaignScreen())))
      ]
    );
  }
}
