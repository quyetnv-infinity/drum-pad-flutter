import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/dialog_unlock_song.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/ads_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/purchase_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/unlock_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/beat_runner/beat_runner_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/item_category_song.dart';
import 'package:drumpad_flutter/src/mvvm/views/iap/iap_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/lessons/lessons_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/loading_data/loading_data_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ListCategorySongWidget extends StatelessWidget {
  final bool isChooseSong;
  final List<SongCollection> songs;

  const ListCategorySongWidget({super.key, required this.isChooseSong, required this.songs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return Consumer<PurchaseProvider>(
          builder: (context, purchaseProvider, _) {
            bool songUnlock = context.watch<UnlockedSongsProvider>().isSongUnlocked(song.id);
            bool isUnlocked = songUnlock || purchaseProvider.isSubscribed;
            return InkWell(
              onTap: () {
                if(!isUnlocked) {
                  showDialogUnlockSongItem(
                    context: context,
                    item: song,
                    onTapGetPremium: () {
                      Navigator.pop(context);
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => IapScreen(),));
                    },
                    onTapWatchAds: () {
                      showRequestRewardUnlockSongDialog(context: context, onUserEarnedReward: () {
                        context.read<UnlockedSongsProvider>().unlockSong(song.id);
                        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LoadingDataScreen(
                          song: song,
                          callbackLoadingFailed: (){
                            Navigator.pop(context);
                          },
                          callbackLoadingCompleted: (songData) {
                            if (isChooseSong) {
                              Navigator.pop(context, songData);
                              Navigator.pop(context, songData);
                            } else {
                              Provider.of<AdsProvider>(context, listen: false).nextScreenFuture(context, () {
                                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LessonsScreen(songCollection: songData,)));
                              });
                            }
                          },
                        ),));
                      },);
                    },
                  );
                  return;
                }
                Navigator.push(context, CupertinoPageRoute(builder: (context) => LoadingDataScreen(
                  song: song,
                  callbackLoadingFailed: (){
                    Navigator.pop(context);
                  },
                  callbackLoadingCompleted: (songData) {
                    if (isChooseSong) {
                      Navigator.pop(context, songData);
                      Navigator.pop(context, songData);
                    } else {
                      Provider.of<AdsProvider>(context, listen: false).nextScreen(context, LessonsScreen(songCollection: songData,), true);
                    }
                  },
                ),));
              },
              child: ItemCategorySong(model: song, isUnlocked: isUnlocked,),
            );
          }
        );
      },
    );
  }
}
