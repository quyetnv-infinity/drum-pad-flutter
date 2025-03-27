import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/beat_runner/beat_runner_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/item_category_song.dart';
import 'package:drumpad_flutter/src/mvvm/views/lessons/lessons_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCategorySongWidget extends StatelessWidget {
  final bool isChooseSong;
  const ListCategorySongWidget({super.key, required this.isChooseSong});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        final song = context.read<DrumLearnProvider>().data[index];
      return InkWell(
        onTap: () {
          if(isChooseSong) {
            Navigator.pop(context, song);
          } else {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => BeatRunnerScreen(songCollection: song,),));
          }
        },
        child: ItemCategorySong(model: song)
      );
      },
    );
  }
}
