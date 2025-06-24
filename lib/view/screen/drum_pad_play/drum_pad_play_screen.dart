import 'package:and_drum_pad_flutter/core/res/drawer/anim.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/add_new_song.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/pick_song_bottom_sheet.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class DrumPadPlayScreen extends StatefulWidget {
  const DrumPadPlayScreen({super.key});

  @override
  State<DrumPadPlayScreen> createState() => _DrumPadPlayScreenState();
}

class _DrumPadPlayScreenState extends State<DrumPadPlayScreen> {
  SongCollection? _songCollection ;
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(iconLeading: ResIcon.icPause, onTapLeading: () { },
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  print('Selected song: ${result.name}');
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddNewSong(BuildContext context) {
    final screenW =  MediaQuery.sizeOf(context).width;
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Image.asset(
            ResImage.imgBgAdd1,
            height: screenW * 0.4,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            ResImage.imgBgAdd2,
            height: screenW * 0.33,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: screenW * 0.45,
          top: 0,
          bottom: 0,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(context.locale.add_new_song, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontFamily: AppFonts.commando)),
                SizedBox(
                  width: 180,
                  child: Text(context.locale.choose_a_song_to_play, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.6)))),
              ],
            ),
          ),
        )
      ],
    );
  }
}
