import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_runner/widget/recommend_list_song.dart';
import 'package:and_drum_pad_flutter/view/screen/campaign/campaign_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/learn_material/learn_material_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/item/mode_play_item.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/drum_learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeatLearnScreen extends StatefulWidget {
  const BeatLearnScreen({super.key});

  @override
  State<BeatLearnScreen> createState() => _BeatLearnScreenState();
}

class _BeatLearnScreenState extends State<BeatLearnScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.sizeOf(context).width * 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 10),
          child: Text(context.locale.beat_learn, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize:20, fontFamily: AppFonts.commando, color: Colors.white)),
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
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Consumer<DrumLearnProvider>(
                  builder: (context, drumLearnProvider, _) {
                    return drumLearnProvider.listSongResume.isEmpty ? Container() : Flexible(
                        child: RecommendListSong(
                          title: context.locale.recent_list_song,
                          listSongs: drumLearnProvider.listSongResume,
                          onTapItem: (song) {

                          },
                        )
                    );
                  }
              ),
              Text(context.locale.mode_play, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white.withValues(alpha: 0.8)),),
              ModePlayItem(asset: ResImage.imgBgLearnMaterial, title: context.locale.learn_material, description: context.locale.learn_material_des,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LearnMaterialScreen(),));
                },
              ),
              ModePlayItem(asset: ResImage.imgBgCampaign, title: context.locale.campaign, description: context.locale.campaign_des,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CampaignScreen(),));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
