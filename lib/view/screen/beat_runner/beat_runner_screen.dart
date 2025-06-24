import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_runner/widget/recommend_list_song.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/item/mode_play_item.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';

class BeatRunnerScreen extends StatelessWidget {
  const BeatRunnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.sizeOf(context).width * 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 10),
          child: Text(context.locale.beat_runner, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize:20, fontFamily: AppFonts.commando)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: IconButtonCustom(iconAsset: ResIcon.icSetting, onTap: () {
            },),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Flexible(
                child: RecommendListSong()
              ),
              ModePlayItem(asset: ResImage.imgBgLearnMaterial, title: context.locale.learn_material, description: context.locale.learn_material_des,
                onTap: () {
                  print('hakhcshjkasfbcas');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
