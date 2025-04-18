import 'dart:convert';

import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/campaign_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/game_play_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/learn_from_song_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/list_song_widget.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrumLearnProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(provider.listSongResume.isNotEmpty) ListSongWidget(title: context.locale.resume, isMore: false, isChooseSong: false, listSongData: provider.listSongResume),
            SizedBox(height: 12),
            OptionsWidget(title: context.locale.learn_from_song, description: context.locale.learn_from_song_des, asset: ResImage.imgLearnFromSong, func: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => LearnFromSongScreen()))),
            SizedBox(height: 12),
            OptionsWidget(title:  context.locale.campaign, description:  context.locale.campaign_des, asset: ResImage.imgCampaign, func: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => CampaignScreen())))
          ]
        );
      }
    );
  }
}
