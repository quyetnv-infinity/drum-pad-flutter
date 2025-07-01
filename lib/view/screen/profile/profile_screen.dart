import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_runner/widget/recommend_list_song.dart';
import 'package:and_drum_pad_flutter/view/screen/completed_songs/completed_songs_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/lessons/lessons_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/profile/widget/completed_songs.dart';
import 'package:and_drum_pad_flutter/view/screen/setting/setting_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/loading_dialog/loading_dialog.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view/widget/text/judgement_text.dart';
import 'package:and_drum_pad_flutter/view_model/drum_learn_provider.dart';
import 'package:and_drum_pad_flutter/view_model/result_information_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final drumLearnProvider = context.watch<DrumLearnProvider>();

    return AppScaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.sizeOf(context).width * 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 10),
          child: Text(context.locale.profile, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize:20, fontFamily: AppFonts.commando, color: Colors.white)),
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withValues(alpha: 0.1)
            ),
            child: Row(
              spacing: 8,
              children: [
                SvgPicture.asset(ResIcon.icStarFull),
                Text((drumLearnProvider.totalStar + drumLearnProvider.beatRunnerStar).toStringAsFixed(0), style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: IconButtonCustom(iconAsset: ResIcon.icSetting, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
            },),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 100),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            accuracyAllSongs(),
            drumLearnProvider.listRecommend.isEmpty ? Container() : Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: RecommendListSong(
                title: context.locale.recommend_list_songs,
                listSongs: drumLearnProvider.listRecommend,
                onTapItem: (song) {

                },
              ),
            ),
            if(drumLearnProvider.completedSongs.isNotEmpty) Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 4),
              child: completedSongs(
                context,
                drumLearnProvider.completedSongs,
                onTapItem: (song) {
                  showDialog(
                    context: context,
                    builder: (context) => LoadingDataScreen(
                      callbackLoadingCompleted: (songResult) {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LessonsScreen(song: songResult),));
                      },
                      callbackLoadingFailed: () {
                        Navigator.pop(context);
                      },
                      song: song
                    ),
                  );
                },
                onTapViewAll: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedSongsScreen(songs: drumLearnProvider.completedSongs,),));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget accuracyAllSongs() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 56),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.locale.accuracy_all_songs, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withValues(alpha: 0.1)
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4).copyWith(left: 40),
                  decoration: BoxDecoration(
                    color: Color(0xFF38154D),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      JudgementText.perfect(context.locale.perfect, underline: true, fontSize: 24, fontWeight: FontWeight.w400, italic: false),
                      JudgementText.good(context.locale.good, underline: true, fontSize: 24, fontWeight: FontWeight.w400, italic: false),
                      JudgementText.early(context.locale.early, underline: true, fontSize: 24, fontWeight: FontWeight.w400, italic: false),
                      JudgementText.late(context.locale.late, underline: true, fontSize: 24, fontWeight: FontWeight.w400, italic: false),
                      JudgementText.miss(context.locale.miss, underline: true, fontSize: 24, fontWeight: FontWeight.w400, italic: false),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4).copyWith(left: 16),
                  child: Consumer<ResultInformationProvider>(
                    builder: (context, resultProvider, _) {
                      return Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// perfect
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(calculatePercent(resultProvider.perfectPoint, resultProvider.totalPoint()).toStringAsFixed(0), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, fontFamily: AppFonts.sigmar, color: Colors.white, height: 0.9),),
                                Text('%', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, fontFamily: AppFonts.sigmar, color: Colors.white),),
                              ],
                            ),
                          ),
                          /// good
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(calculatePercent(resultProvider.goodPoint, resultProvider.totalPoint()).toStringAsFixed(0), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, fontFamily: AppFonts.sigmar, color: Colors.white, height: 0.9),),
                                Text('%', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, fontFamily: AppFonts.sigmar, color: Colors.white),),
                              ],
                            ),
                          ),
                          /// early
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(calculatePercent(resultProvider.earlyPoint, resultProvider.totalPoint()).toStringAsFixed(0), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, fontFamily: AppFonts.sigmar, color: Colors.white, height: 0.9),),
                                Text('%', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, fontFamily: AppFonts.sigmar, color: Colors.white),),
                              ],
                            ),
                          ),
                          /// late
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(calculatePercent(resultProvider.latePoint, resultProvider.totalPoint()).toStringAsFixed(0), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, fontFamily: AppFonts.sigmar, color: Colors.white, height: 0.9),),
                                Text('%', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, fontFamily: AppFonts.sigmar, color: Colors.white),),
                              ],
                            ),
                          ),
                          /// miss
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(calculateMissPercent(resultProvider).toStringAsFixed(0), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, fontFamily: AppFonts.sigmar, color: Colors.white, height: 0.9),),
                                Text('%', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, fontFamily: AppFonts.sigmar, color: Colors.white),),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  double calculatePercent(int point, int totalPoint) {
    if (totalPoint == 0) return 0;
    final percent = (point / totalPoint) * 100;
    return percent.floorToDouble();
  }

  double calculateMissPercent(ResultInformationProvider resultProvider){
    if(resultProvider.totalPoint() == 0) return 0;
    return 100 - (
        calculatePercent(resultProvider.perfectPoint, resultProvider.totalPoint()) +
        calculatePercent(resultProvider.goodPoint, resultProvider.totalPoint()) +
        calculatePercent(resultProvider.earlyPoint, resultProvider.totalPoint()) +
        calculatePercent(resultProvider.latePoint, resultProvider.totalPoint())
    );
  }
}
