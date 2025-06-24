import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_runner/widget/recommend_list_song.dart';
import 'package:and_drum_pad_flutter/view/screen/category/category_details_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/item/mode_play_item.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/drum_learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: IconButtonCustom(iconAsset: ResIcon.icSetting, onTap: () {
            },),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16).copyWith(right: 0),
          child: Column(
            children: [
              Consumer<DrumLearnProvider>(
                builder: (context, drumLearnProvider, _) {
                  return drumLearnProvider.listRecommend.isEmpty ? Container() : Flexible(
                    child: RecommendListSong(
                      title: context.locale.recommend_list_songs,
                      listSongs: drumLearnProvider.listRecommend,
                      onTapItem: () {

                      },
                    )
                  );
                }
              ),
              IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetailsScreen(),));
              }, icon: Icon(Icons.next_plan))
            ],
          ),
        ),
      ),
    );
  }
}
