import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';

class LessonsScreen extends StatefulWidget {
  final SongCollection song;
  const LessonsScreen({super.key, required this.song});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
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
    );
  }
}
