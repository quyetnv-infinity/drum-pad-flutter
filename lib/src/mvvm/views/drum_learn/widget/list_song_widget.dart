import 'package:drumpad_flutter/core/utils/dialog_unlock_song.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/category_model.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/ads_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/category_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/purchase_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/unlock_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/learn_category_details.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/song_item.dart';
import 'package:drumpad_flutter/src/mvvm/views/iap/iap_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/lessons/lessons_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/loading_data/loading_data_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListSongWidget extends StatefulWidget {
  final String title;
  final bool isMore;
  final bool isChooseSong;
  final String? categoryCode;
  final List<SongCollection> listSongData;
  const ListSongWidget({super.key, required this.title, required this.isMore, required this.isChooseSong, required this.listSongData, this.categoryCode});

  @override
  State<ListSongWidget> createState() => _ListSongWidgetState();
}

class _ListSongWidgetState extends State<ListSongWidget> {
  SongCollection? _currentSongSelected;
  List<SongCollection> _listSongData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getListByCategory();
    },);
  }

  Future<void> getListByCategory() async {
    if(!widget.isMore) {
      print('get resume');
      setState(() {
        _listSongData = context.read<DrumLearnProvider>().listSongResume;
      });
      return;
    }else if(widget.listSongData.isNotEmpty) {
      setState(() {
        _listSongData = widget.listSongData;
      });
    } else {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      setState(() {
        _listSongData = (categoryProvider.categories.firstWhere((element) => element.code == widget.categoryCode, orElse: () => Category(code: '', name: '', items: [])).items ?? []).take(5).toList();
      });
    }
    setState(() {
      if(widget.isMore) _listSongData = sortByDifficulty(_listSongData);
    });
  }

  List<SongCollection> sortByDifficulty(List<SongCollection> songs){
    final difficultyOrder = {
      DifficultyMode.easy: 0,
      DifficultyMode.medium: 1,
      DifficultyMode.hard: 2,
      DifficultyMode.demonic: 3,
    };

    return List<SongCollection>.from(songs)..sort((a, b) {
      final aOrder = difficultyOrder[a.difficulty] ?? 4;
      final bOrder = difficultyOrder[b.difficulty] ?? 4;
      return aOrder.compareTo(bOrder);
    });
  }

  @override
  void didUpdateWidget(ListSongWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listSongData != oldWidget.listSongData && !widget.isMore) {
      setState(() {
        _listSongData = context.read<DrumLearnProvider>().listSongResume;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),),
              if(widget.isMore) InkWell(
                onTap: () async {
                  final result = await Navigator.push(context, CupertinoPageRoute(builder: (context) => LearnCategoryDetails(category: widget.title, isChooseSong: widget.isChooseSong, categoryCode: widget.categoryCode ?? '',),));
                  if(result != null && widget.isChooseSong){
                    setState(() {
                      _currentSongSelected = result;
                    });
                    Navigator.pop(context, _currentSongSelected);
                  }
                },
                child: Row(
                  children: [
                    Text(context.locale.more, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),),
                    Icon(Icons.chevron_right_rounded, size: 22)
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: MediaQuery.sizeOf(context).width * 0.67,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _listSongData.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final song = _listSongData[index];
              return Consumer<PurchaseProvider>(
                builder: (context, purchaseProvider, _) {
                  bool songUnlock = context.watch<UnlockedSongsProvider>().isSongUnlocked(song.id);
                  bool isUnlocked = songUnlock || purchaseProvider.isSubscribed || !widget.isMore;
                  return GestureDetector(
                    onTap: (){
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
                              Navigator.push(context, CupertinoPageRoute(builder: (context) => LoadingDataScreen(
                                song: song,
                                callbackLoadingFailed: (){
                                  Navigator.pop(context);
                                },
                                callbackLoadingCompleted: (songData) async {
                                  // await Provider.of<AdsProvider>(context, listen: false).nextScreenFuture(context,LessonsScreen(songCollection: songData,),true);
                                  if(widget.isChooseSong){
                                    Navigator.pop(context, songData);
                                    Navigator.pop(context, songData);
                                  }else{
                                    await Provider.of<AdsProvider>(context, listen: false).nextScreenFuture(context, () {
                                    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LessonsScreen(songCollection: songData,)));},);
                                    await getListByCategory();
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
                        callbackLoadingCompleted: (songData) async {
                          if(widget.isChooseSong){
                            Navigator.pop(context, songData);
                            Navigator.pop(context, songData);
                          }else{
                            await Provider.of<AdsProvider>(context, listen: false).nextScreenFuture(context, () {
                              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LessonsScreen(songCollection: songData,)));
                            },);
                            await getListByCategory();
                          }
                        },
                      ),));
                      },
                    child: SongItem(
                      isFromLearnFromSong: !widget.isChooseSong,
                      model: song,
                      isUnlocked: isUnlocked,
                    ),
                  );
                }
              );
            })
        ),
      ]
    );
  }
}
