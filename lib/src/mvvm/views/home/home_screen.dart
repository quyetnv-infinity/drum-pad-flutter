import 'dart:ui';

import 'package:ads_tracking_plugin/collapsible_banner_ad/collapsible_banner_ad_widget.dart';
import 'package:ads_tracking_plugin/utils/network_checking.dart';
import 'package:drumpad_flutter/core/constants/unlock_song_quantity.dart';
import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/res/style/text_style.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/core/utils/network_checking.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/ads_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/campaign_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/background_audio_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/network_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/purchase_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/unlock_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/home/widgets/button_action.dart';
import 'package:drumpad_flutter/src/mvvm/views/home/widgets/horizontal_list.dart';
import 'package:drumpad_flutter/src/mvvm/views/iap/iap_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/lessons/lessons_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/beat_runner/beat_runner_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/drum_learn_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/loading_data/loading_data_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/profile/profile_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/setting/setting_screen.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SongCollection> _dataBeatRunner = [];
  List<SongCollection> _dataDrumLearn = [];
  List<SongCollection> recommendSongs = [];
  late NetworkProvider networkProvider;
  late AdsProvider adsProvider;
  late BackgroundAudioProvider backgroundAudioProvider;
  bool _isDialogNetworkShown = false;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    adsProvider = Provider.of<AdsProvider>(context, listen: false);
    backgroundAudioProvider = Provider.of<BackgroundAudioProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      backgroundAudioProvider.play();
    });
    networkProvider.addListener(checkNetwork);
    _initializeData();
  }

  @override
  void dispose() {
    networkProvider.removeListener(checkNetwork);
    super.dispose();
  }

  Future<void> _initializeData() async {
    if (_isLoading) return;
    _isLoading = true;

    await fetchData();
    await fetchRecommendSongs();
    _isLoading = false;
  }

  void checkNetwork(){
    if(_dataBeatRunner.isNotEmpty || _dataDrumLearn.isNotEmpty) {
      print('data exist');
      return;
    }
    if(networkProvider.isConnected){
      if(_isDialogNetworkShown) Navigator.pop(context);
    }
    NetworkChecking.checkNetwork(
      context,
      handleActionWhenComplete: () {
        setState(() {
          _isDialogNetworkShown = false;
        });
        if(!networkProvider.isConnected) return;
        _initializeData();
        print('reload data');
      },
      handleWhenShowDialog: () {
        setState(() {
          _isDialogNetworkShown = true;
        });
      },
    );
  }

  Future<void> fetchData() async {
    final campaignProvider = Provider.of<CampaignProvider>(context, listen: false);
    final unlockProvider = Provider.of<UnlockedSongsProvider>(context, listen: false);
    await campaignProvider.fetchCampaignSong(isEasy: true);
    final easyCampaign = campaignProvider.easyCampaign;

    _dataDrumLearn = easyCampaign.take(3).toList();

    if (easyCampaign.length > 3) {
      _dataBeatRunner = easyCampaign.skip(3).take(3).toList();
    } else {
      _dataBeatRunner = [];
    }
    final songsToUnlock = easyCampaign.take(unlockSongQuantity*2).toList();
    for (var song in songsToUnlock) {
      unlockProvider.unlockSong(song.id);
    }
    setState(() {});
  }

  Future<void> fetchRecommendSongs() async {
    final drumLearnProvider = Provider.of<DrumLearnProvider>(context, listen: false);
    if(drumLearnProvider.listRecommend.isEmpty) {
      await context.read<DrumLearnProvider>().getRecommend();
    }
    setState(() {
      recommendSongs = drumLearnProvider.listRecommend;
    });
  }

  @override
  Widget build(BuildContext context) {

    return CustomScaffold(
      bottomNavigationBar: Consumer<PurchaseProvider>(
        builder: (context, purchaseProvider, _) {
          return !purchaseProvider.isSubscribed ? const SafeArea(child: CollapsibleBannerAdWidget(adName: "banner_collap_all")) : const SizedBox.shrink();
        }
      ),
      backgroundType: BackgroundType.gradient,
      appBar: AppBar(
        centerTitle: false,
        title: Consumer<BackgroundAudioProvider>(
          builder: (context, provider, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    provider.toggle();
                  },
                  child: SvgPicture.asset(
                    provider.isPlaying
                        ? 'assets/icons/ic_pause.svg'
                        : 'assets/icons/ic_play.svg',
                    width: 30,
                  ),
                ),
                SizedBox(width: 6), // spacing giữa nút và text
                provider.isPlaying
                    ? Expanded(
                  child: SizedBox(
                    height: 24,
                    child: Marquee(
                      text: '${context.locale.playing}: ${provider.playingSong()} ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 50.0,
                      velocity: 30.0,
                      startPadding: 10.0,
                      accelerationDuration: Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),
                  ),
                )
                    : Expanded(
                  child: Text(
                    '${provider.playingSong()} ',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            );
          },
        ),
        actions: [
          Consumer<PurchaseProvider>(
            builder: (context, purchaseProvider, _) {
              if (purchaseProvider.isSubscribed) return SizedBox.shrink();
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => IapScreen()
                    ),
                  );
                },
                icon: SvgPicture.asset(ResIcon.icIAP),
              );
            }
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
            icon: SvgPicture.asset(ResIcon.icProfile),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SettingScreen(),
                ),
              );
            },
            icon: SvgPicture.asset(ResIcon.icSettingOutline),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: recommendSongs.isNotEmpty ? Text(
                context.locale.recommend,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ) : SizedBox.shrink(),
            ),
            SizedBox(height: 12),
            HorizontalList(
              width: 120,
              height: 120,
              data: recommendSongs,
              isShowDifficult: true,
              onTap: (item, index) async{
                final random = DateTime.now().millisecondsSinceEpoch % 2 == 0;
                await Navigator.push(context, CupertinoPageRoute(builder: (context) => LoadingDataScreen(
                  song: item,
                  callbackLoadingFailed: (){
                    Navigator.pop(context);
                  },
                  callbackLoadingCompleted: (song) async {
                    await adsProvider.nextScreen(context, random ? LessonsScreen(songCollection: song,) : BeatRunnerScreen(songCollection: song), true);
                    print('NAVIAGTE ===========');
                    // await backgroundAudioProvider.play();
                  },
                ),));
              },
            ),
            ButtonAction(
              title: context.locale.beat_runner,
              content: context.locale.sub_button_beat_runner,
              imageBackground: ResImage.imgBgButtonBeatRunner,
              onPressed: ()async {
                await adsProvider.nextScreen(context, BeatRunnerScreen(), false);
                if(backgroundAudioProvider.isPlaying) await backgroundAudioProvider.play();
              },
            ),
            HorizontalList(
              width: 180,
              height: 240,
              data: _dataBeatRunner,
              onTap: (item, index) {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => LoadingDataScreen(
                  song: item,
                  callbackLoadingFailed: (){
                    Navigator.pop(context);
                  },
                  callbackLoadingCompleted: (song) {
                    adsProvider.nextScreen(context, BeatRunnerScreen(songCollection: song), true);
                  },
                ),));
              },
            ),
            ButtonAction(
              title: context.locale.drum_learn,
              content: context.locale.sub_button_drum_learn,
              imageBackground: ResImage.imgBgButtonBeatRunner,
              onPressed: () async{
               await Navigator.push(context, CupertinoPageRoute(builder: (context) => DrumLearnScreen(),));
               if(backgroundAudioProvider.homePlaying) await backgroundAudioProvider.play();
              },
            ),
            HorizontalList(
              width: 180,
              height: 240,
              data: _dataDrumLearn,
              isShowDifficult: true,
              onTap: (item, index) {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => LoadingDataScreen(
                  song: item,
                  callbackLoadingFailed: (){
                    Navigator.pop(context);
                  },
                  callbackLoadingCompleted: (song) {
                    adsProvider.nextScreen(context, LessonsScreen(songCollection: song,), true);
                  },
                ),));
              },
            ),
          ],
        ),
      ),
    );
  }
}
