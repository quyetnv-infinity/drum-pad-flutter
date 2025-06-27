import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/add_new_song.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/song_score_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/drum_pad/drum_pad_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/loading_dialog/exit_dialog.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrumPadPlayScreen extends StatefulWidget {
  final SongCollection songCollection;
  const DrumPadPlayScreen({super.key, required this.songCollection});

  @override
  State<DrumPadPlayScreen> createState() => _DrumPadPlayScreenState();
}

class _DrumPadPlayScreenState extends State<DrumPadPlayScreen> {
  double _starPercent = 0;
  int _score = 0;
  int _perfectPoint = 0;
  late SongCollection _currentSong;

  @override
  void initState() {
    super.initState();
    _currentSong = widget.songCollection;

  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(iconLeading: ResIcon.icPause, onTapLeading: () {
        showDialog(context: context, barrierDismissible: false, barrierColor: Colors.black.withValues(alpha: 0.9),
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: ExitDialog(
              onTapCancel: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              onTapContinue: () {
                Navigator.pop(context);
              },
            )
          )
        );
        // Navigator.pop(context);
      },
        titleWidget: _buildTitle(),
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
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SongScoreWidget(songCollection: _currentSong, starPercent: _starPercent, score: _score, perfectPoint: _perfectPoint,),
            ),
          ),
          // Spacer(),
          DrumPadScreen(
            onChangePerfectPoint: (perfectPoint) {
              setState(() {
                _perfectPoint = perfectPoint;
              });
              if(_perfectPoint == 0){
                print('perfectPoint =00000000');
              }
              print(perfectPoint);
              print('perfectPoint');
            },
            currentSong: _currentSong,
            onChangeStarLearn:(star) {
              setState(() {
                _starPercent = star;
              });
            },
            onChangeScore: (score) {
              setState(() {
                _score = score;
              });
            },
            onTapChooseSong:(song) {
              setState(() {
                _currentSong = song;
              });
            },
            isFromLearnScreen: false,
            isFromCampaign: false
          )
        ],
      ),
    );
  }

  Widget _buildTitle(){
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Row(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(ResIcon.icWaveForm),
          Expanded(child: Text("${widget.songCollection.name} - ${widget.songCollection.author}", style: TextStyle(fontSize: 16),))
        ],
      ),
    );
  }
}
