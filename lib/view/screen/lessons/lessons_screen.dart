import 'package:and_drum_pad_flutter/core/res/dimen/spacing.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/learn_drum_pad/learn_drum_pad_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/list_item/campaign_item.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/campaign_provider.dart';
import 'package:and_drum_pad_flutter/view_model/drum_learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LessonsScreen extends StatefulWidget {
  final SongCollection song;
  const LessonsScreen({super.key, required this.song});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  List<LessonSequence> _lessons = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchLessonData();
    },);
  }

  Future<void> fetchLessonData() async {
    final drumLearnProvider = Provider.of<DrumLearnProvider>(context, listen: false);
    if(_lessons.isEmpty) {
      setState(() {
        _lessons = widget.song.lessons;
      });
      return;
    }
    final song = await drumLearnProvider.getSong(widget.song.id);
    if(song != null && song.lessons.isNotEmpty) {
      setState(() {
        _lessons = song.lessons;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        iconLeading: ResIcon.icBack,
        onTapLeading: () {
          Navigator.pop(context);
        },
        title: widget.song.name,
      ),
      body: Column(
        children: [
          _summaryWidget(),
          ResSpacing.h20,
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _lessons.length,
              padding: EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (context, index) => ResSpacing.h8,
              itemBuilder: (context, index) {
                final lesson = _lessons[index];
                final isLocked = index == 0 ? false : (_lessons[index - 1].isCompleted ? false : true);
                return Stack(
                  children: [
                    CampaignItem(
                      trailingWidget: isLocked ? SizedBox.shrink() : _buildTrailingWidget(lesson, index),
                      score: (lesson.perfectScore ?? 0) + (lesson.goodScore ?? 0) + (lesson.earlyScore ?? 0) + (lesson.lateScore ?? 0),
                      star: lesson.star >= 3 ? 100 : (lesson.star >= 2 ? 75 : (lesson.star >= 1 ? 45 : 0)),
                      name: Text('${context.locale.step} ${index + 1}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),)
                    ),
                    if(isLocked) Positioned.fill(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withValues(alpha: 0.6)
                        ),
                        child: Row(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if((index == 1 && !_lessons[0].isCompleted) || (index >= 2 && _lessons[index-2].isCompleted)) Text(context.locale.need_2_stars_to_unlock, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white),),
                            SvgPicture.asset(ResIcon.icLock)
                          ],
                        )
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onTapToPlay(int index) async {
    await context.read<DrumLearnProvider>().addToResume(widget.song.id);
    Provider.of<CampaignProvider>(context, listen: false).setCurrentLessonCampaign(index);
    await Navigator.push(context, MaterialPageRoute(builder: (context) => LearnDrumPadScreen(songCollection: widget.song.copyWith(lessons: _lessons), lessonIndex: index,)));
    print('FETCH LESSON DATA ------------------');
    await fetchLessonData();
  }

  Widget _buildTrailingWidget(LessonSequence lesson, int index) {
    if(lesson.isCompleted) {
      return InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () async {
          await _onTapToPlay(index);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.6))
          ),
          child: Text(context.locale.replay, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontWeight: FontWeight.w500, fontSize: 14),),
        ),
      );
    }
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () async {
        await _onTapToPlay(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(colors: [Color(0xFFA005FF), Color(0xFFD796FF)])
        ),
        child: Text(context.locale.play, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),),
      ),
    );
  }

  Widget _summaryWidget() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withValues(alpha: 0.1)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 32,
        children: [
          Row(
            spacing: 8,
            children: [
              SvgPicture.asset(ResIcon.icStarFull),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  children: [
                    TextSpan(text: '${getTotalStar()}/', style: TextStyle(color: Colors.white)),
                    TextSpan(text: '${_lessons.length*3}', style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),
                  ]
                )
              )
            ],
          ),
          Row(
            spacing: 8,
            children: [
              SvgPicture.asset(ResIcon.icGridPad),
              RichText(
                  text: TextSpan(
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      children: [
                        TextSpan(text: '${getLessonPlayed()}/', style: TextStyle(color: Colors.white)),
                        TextSpan(text: '${_lessons.length}', style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),
                      ]
                  )
              )
            ],
          )
        ],
      ),
    );
  }

  int getTotalStar() {
    double starSum = 0;
    for (var lesson in _lessons) {
      starSum += lesson.star;
    }
    return starSum.floor();
  }

  int getLessonPlayed() {
    int total = 0;
    for (var lesson in _lessons) {
      if(lesson.star != 0) {
        total++;
      }
    }
    return total;
  }
}
