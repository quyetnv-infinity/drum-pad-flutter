import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LearnDrumPadScreen extends StatefulWidget {
  final SongCollection songCollection;
  const LearnDrumPadScreen({super.key, required this.songCollection});

  @override
  State<LearnDrumPadScreen> createState() => _LearnDrumPadScreenState();
}

class _LearnDrumPadScreenState extends State<LearnDrumPadScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
