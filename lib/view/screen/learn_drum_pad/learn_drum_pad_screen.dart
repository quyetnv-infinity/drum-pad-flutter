import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/song_score_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/drum_pad/drum_pad_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/campaign_provider.dart';
import 'package:and_drum_pad_flutter/view_model/drum_learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LearnDrumPadScreen extends StatefulWidget {
  final SongCollection songCollection;
  final int lessonIndex;
  const LearnDrumPadScreen({super.key, required this.songCollection, required this.lessonIndex});

  @override
  State<LearnDrumPadScreen> createState() => _LearnDrumPadScreenState();
}

class _LearnDrumPadScreenState extends State<LearnDrumPadScreen> {
  final GlobalKey _widgetPadKey = GlobalKey();
  int _currentScore = 0;
  double _percentStar = 0;
  bool _isRecordingSelected = false;
  bool _isPlaying = false;
  int _perfectPoint = 0;

  Future<void> updateUnlockedLesson() async {
    final drumLearnProvider = Provider.of<DrumLearnProvider>(context, listen: false);
    final campaignProvider = Provider.of<CampaignProvider>(context, listen: false);
    List<LessonSequence> updatedLessons = (await drumLearnProvider.getSong(widget.songCollection.id))!.lessons;

    final indexUpdated = campaignProvider.currentLessonCampaign;
    print('unlocked $indexUpdated');
    if (indexUpdated < updatedLessons.length) {
      updatedLessons[indexUpdated].isCompleted = true;
    }

    final newSong = widget.songCollection.copyWith(lessons: updatedLessons);
    await drumLearnProvider.updateSong(widget.songCollection.id, newSong);
  }

  Future<void> updateLessonStar(double star) async {
    final provider = Provider.of<DrumLearnProvider>(context, listen: false);
    final campaignProvider = Provider.of<CampaignProvider>(context, listen: false);
    List<LessonSequence> updatedLessons = (await provider.getSong(widget.songCollection.id))!.lessons;
    updatedLessons[campaignProvider.currentLessonCampaign].star = star;
    print('update star $star at ${campaignProvider.currentLessonCampaign}');
    final newSong = widget.songCollection.copyWith(lessons: updatedLessons);
    await provider.updateSong(widget.songCollection.id, newSong);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AppScaffold(
        appBar: CustomAppBar(
          iconLeading: ResIcon.icBack,
          onTapLeading: () {
            Navigator.pop(context);
          },
          titleWidget: _buildTitle(),
          action: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButtonCustom(
                iconAsset: ResIcon.icRecord,
                onTap:() {

                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButtonCustom(
                iconAsset: ResIcon.icTutorial,
                onTap:() {

                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SongScoreWidget(songCollection: widget.songCollection, starPercent: _percentStar, score: _currentScore, perfectPoint: _perfectPoint,),
                ),
              ),
              DrumPadScreen(
                key: _widgetPadKey,
                lessonIndex: widget.lessonIndex,
                currentSong: widget.songCollection,
                onChangeScore: (int score, ) {
                  setState(() {
                    _currentScore = score;
                  });
                },
                onChangeStarLearn: (star) {
                  setState(() {
                    _percentStar = star ;
                    print(star);
                  });
                },
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
                onChangeUnlockedModeCampaign: () async {
                  await updateUnlockedLesson();
                },
                onChangeCampaignStar: (star) async {
                  await updateLessonStar(star);
                },
                isFromLearnScreen: true,
                isFromCampaign: false,
                onResetRecordingToggle: () {
                  setState(() {
                    _isRecordingSelected = false;
                  });
                },
                onChangePlayState: (isPlaying) {
                  setState(() {
                    _isPlaying = isPlaying;
                  });
                },
              )
            ],
          ),
        ),
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
