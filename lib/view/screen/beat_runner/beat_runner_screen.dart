import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_runner/widget/recommend_list_song.dart';
import 'package:and_drum_pad_flutter/view/screen/category/category_details_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/free_style/free_style_play_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/setting/setting_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/runner_play/drum_pad_play_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/item/mode_play_item.dart';
import 'package:and_drum_pad_flutter/view/widget/list_view/mood_and_genres.dart';
import 'package:and_drum_pad_flutter/view/widget/loading_dialog/loading_dialog.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/ads_provider.dart';
import 'package:and_drum_pad_flutter/view_model/drum_learn_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeatRunnerScreen extends StatefulWidget {
  const BeatRunnerScreen({super.key});

  @override
  State<BeatRunnerScreen> createState() => _BeatRunnerScreenState();
}

class _BeatRunnerScreenState extends State<BeatRunnerScreen> {
  late AdsProvider adsProvider;

  @override
  void initState() {
    super.initState();
    adsProvider = Provider.of<AdsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.sizeOf(context).width * 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 10),
          child: Text(context.locale.beat_runner, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize:20, fontFamily: AppFonts.commando, color: Colors.white)),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: IconButtonCustom(iconAsset: ResIcon.icSetting, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
            },),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16).copyWith(right: 0),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
            child: Column(
              children: [
                Consumer<DrumLearnProvider>(
                  builder: (context, drumLearnProvider, _) {
                    return drumLearnProvider.listRecommend.isEmpty ? SizedBox.shrink() : RecommendListSong(
                      title: context.locale.recommend_list_songs,
                      listSongs: drumLearnProvider.listRecommend,
                      onTapItem: (song) {
                        showDialog(context: context, builder: (context) => LoadingDataScreen(
                          callbackLoadingCompleted: (song) {
                            adsProvider.showInterAd(
                              name: "inter_home",
                              callback: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DrumPadPlayScreen(songCollection: song)));
                              }
                            );
                          },
                          callbackLoadingFailed: () {
                            Navigator.pop(context);
                          },
                          song: song
                        )
                        );
                      },
                    );
                  }
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ModePlayItem(asset: ResImage.imgBgPadDrum, title: context.locale.freestyle_pad_drum, description: context.locale.pad_drum_des,
                    onTap: () {
                      adsProvider.showInterAd(
                        name: "inter_home",
                        callback: () {
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => FreeStylePlayScreen()));
                        }
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                MoodAndGenres(
                  onTapCategory: (category) {
                    adsProvider.showInterAd(
                      name: "inter_home",
                      callback: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetailsScreen(category: category,),));
                      }
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
