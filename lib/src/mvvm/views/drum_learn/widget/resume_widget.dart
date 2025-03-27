import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/drum_learn_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/learn_from_song_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/options_widget.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/song_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResumeWidget extends StatelessWidget {
  const ResumeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text('Resume', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),)
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: MediaQuery.sizeOf(context).width * 0.67,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
            return SongItem(height: MediaQuery.sizeOf(context).width * 0.55, isFromLearnFromSong: false,);
          },),
        ),
        SizedBox(height: 12),
        OptionsWidget(title: 'Learn From Song', description: 'Learn too play Drumpad on device with a specific song that you love', asset: ResImage.imgLearnFromSong, func: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => LearnFromSongScreen()))),
        SizedBox(height: 12),
        OptionsWidget(title: 'Campaign', description: 'Complete a roadmap as you learn to play and keep track of your progress', asset: ResImage.imgCampaign, func: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => DrumLearnScreen())))
      ]
    );
  }
}
