import 'package:and_drum_pad_flutter/core/res/dimen/spacing.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/add_new_song.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/pick_song_bottom_sheet.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/drum_pad/drum_pad_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';

class DrumPadPlayScreen extends StatefulWidget {
  const DrumPadPlayScreen({super.key});

  @override
  State<DrumPadPlayScreen> createState() => _DrumPadPlayScreenState();
}

class _DrumPadPlayScreenState extends State<DrumPadPlayScreen> with SingleTickerProviderStateMixin {
  final GlobalKey _widgetPadKey = GlobalKey();
  SongCollection? _songCollection ;
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(iconLeading: ResIcon.icBack, onTapLeading: () {
        Navigator.pop(context);
      },
        action: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButtonCustom(iconAsset: ResIcon.icTutorial, onTap:() {

              },
            ),
          ),
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 28),
              child: AddNewSong(
                songCollection: _songCollection,
                onTap: () async {
                  final result = await showModalBottomSheet<SongCollection>(
                    isScrollControlled: true,
                    barrierColor: Colors.black.withValues(alpha: 0.8),
                    context: context,
                    builder: (context) => PickSongScreen(),
                  );
                  if (result != null) {
                    setState(() {
                      _songCollection = result;
                    });
                    print('Selected song: ${result.lessons.length}');
                  }
                },
                onTapClearSong: () {
                  print('asdasdsa');
                  setState(() {
                    _songCollection = null;
                  });
              },
            ),
          ),
          Spacer(),
          DrumPadScreen(
            key: _widgetPadKey,
            lessonIndex: (_songCollection?.lessons.length ?? 0) - 1,
            currentSong: _songCollection,
            practiceMode: 'practice',
            onChangeScore: (int score, ) {

            },
            onChangeStarLearn: (star) {

            },
            onChangeUnlockedModeCampaign: () {
            },
            onChangeCampaignStar: (star) async {

            },
            isFromLearnScreen: true,
            isFromCampaign: false,
            onResetRecordingToggle: () {
              // setState(() {
              //   _isRecordingSelected = false;
              // });
            },
            onChangePlayState: (isPlaying) {
              // setState(() {
              //   _isPlaying = isPlaying;
              // });
            },
          ),
          ResSpacing.h48
        ],
      ),
    );
  }
}
