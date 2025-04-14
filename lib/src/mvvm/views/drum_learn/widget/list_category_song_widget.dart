import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/views/beat_runner/beat_runner_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/item_category_song.dart';
import 'package:drumpad_flutter/src/mvvm/views/lessons/lessons_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/loading_data/loading_data_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ListCategorySongWidget extends StatelessWidget {
  final bool isChooseSong;
  final List<SongCollection> songs;

  const ListCategorySongWidget({super.key, required this.isChooseSong, required this.songs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return InkWell(
          onTap: () {
            if (isChooseSong) {
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LoadingDataScreen(
                song: song,
                callbackLoadingFailed: (){
                  Navigator.pop(context);
                },
                callbackLoadingCompleted: (songData) {
                  Navigator.pop(context, songData);
                  Navigator.pop(context, songData);
                },
              ),));
            } else {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => LoadingDataScreen(
                song: song,
                callbackLoadingFailed: (){
                  Navigator.pop(context);
                },
                callbackLoadingCompleted: (songData) {
                  Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LessonsScreen(songCollection: songData,),));
                },
              ),));
            }
          },
          child: ItemCategorySong(model: song),
        );
      },
    );
  }
}
