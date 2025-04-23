import 'dart:ui';

import 'package:ads_tracking_plugin/collapsible_banner_ad/collapsible_banner_ad_widget.dart';
import 'package:ads_tracking_plugin/utils/network_checking.dart';
import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/res/style/text_style.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/core/utils/network_checking.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/ads_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/network_provider.dart';
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
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<SongCollection> _data;
  List<SongCollection> recommendSongs = [];
  late NetworkProvider networkProvider;
  late AdsProvider adsProvider;
  bool _isDialogNetworkShown = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    adsProvider = Provider.of<AdsProvider>(context, listen: false);
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
    if(_data.isNotEmpty) {
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
    _data = context.read<DrumLearnProvider>().data;
  }

  Future<void> fetchRecommendSongs() async {
    final drumLearnProvider = Provider.of<DrumLearnProvider>(context, listen: false);
    if(drumLearnProvider.listRecommend.isEmpty) {
      await context.read<DrumLearnProvider>().getRecommend();
      setState(() {
        recommendSongs = drumLearnProvider.listRecommend;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      bottomNavigationBar: const SafeArea(child: CollapsibleBannerAdWidget(adName: "banner_collap_all")),
      backgroundType: BackgroundType.gradient,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          context.locale.drum_pad.toUpperCase(),
          style: TextStyle(
            fontFamily: AppFonts.ethnocentric,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => IapScreen()
                ),
              );
            },
            icon: SvgPicture.asset(ResIcon.icIAP),
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
              child: Text(
                context.locale.recommend,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 12),
            HorizontalList(
              width: 120,
              height: 120,
              data: recommendSongs,
              isShowDifficult: true,
              onTap: (item, index) {
                final random = DateTime.now().millisecondsSinceEpoch % 2 == 0;
                Navigator.push(context, CupertinoPageRoute(builder: (context) => LoadingDataScreen(
                  song: item,
                  callbackLoadingFailed: (){
                    Navigator.pop(context);
                  },
                  callbackLoadingCompleted: (song) {
                    adsProvider.nextScreen(context, random ? LessonsScreen(songCollection: song,) : BeatRunnerScreen(songCollection: song), true);
                  },
                ),));
              },
            ),
            ButtonAction(
              title: context.locale.beat_runner,
              content: context.locale.sub_button_beat_runner,
              imageBackground: ResImage.imgBgButtonBeatRunner,
              onPressed: () {
                adsProvider.nextScreen(context, BeatRunnerScreen(), false);
              },
            ),
            HorizontalList(
              width: 180,
              height: 240,
              data: _data,
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
              onPressed: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => DrumLearnScreen(),));
              },
            ),
            HorizontalList(
              width: 180,
              height: 240,
              data: _data,
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
