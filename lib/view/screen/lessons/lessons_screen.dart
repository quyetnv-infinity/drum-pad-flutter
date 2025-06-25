import 'package:and_drum_pad_flutter/core/res/dimen/spacing.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
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
    if(song != null) {
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
              separatorBuilder: (context, index) => ResSpacing.h8,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.white.withValues(alpha: 0.4),
                );
              },
            ),
          )
        ],
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
