import 'package:ads_tracking_plugin/collapsible_banner_ad/collapsible_banner_ad_widget.dart';
import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/res/style/text_style.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/campaign_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/beat_runner/beat_runner_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/game_play_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/loading_data/loading_data_screen.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ModeCampaignScreen extends StatefulWidget {
  final List<SongCollection> listCampaignSong;
  final String difficult;
  const ModeCampaignScreen({super.key, required this.listCampaignSong, required this.difficult});

  @override
  State<ModeCampaignScreen> createState() => _ModeCampaignScreenState();
}

class _ModeCampaignScreenState extends State<ModeCampaignScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  List<SongCollection> _campaignSongs = [];

  bool get isEasy => widget.difficult == DifficultyMode.easy;
  bool get isMedium => widget.difficult == DifficultyMode.medium;
  bool get isHard => widget.difficult == DifficultyMode.hard;
  bool get isDemonic => widget.difficult == DifficultyMode.demonic;

  @override
  void initState() {
    super.initState();
    _campaignSongs = widget.listCampaignSong;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    final provider = Provider.of<CampaignProvider>(context, listen: false);
    await provider.fetchCampaignSong(isEasy: isEasy, isMedium: isMedium, isHard: isHard, isDemonic: isDemonic);
    setState(() {
      _campaignSongs = isEasy ? provider.easyCampaign : (isMedium ? provider.mediumCampaign : (isHard ? provider.hardCampaign : provider.demonicCampaign));
    });
    print('new star: ${_campaignSongs.first.campaignStar}');
  }

  int getUnlockedIndex(CampaignProvider campaignProvider){
    switch(widget.difficult){
      case DifficultyMode.easy:
        return campaignProvider.easyUnlocked;
      case DifficultyMode.medium:
        return campaignProvider.mediumUnlocked;
      case DifficultyMode.hard:
        return campaignProvider.hardUnlocked;
      case DifficultyMode.demonic:
        return campaignProvider.demonicUnlocked;
      default: return 0;
    }
  }

  String _getStarIcon(double star) {
    if (star == 0) {
      return ResIcon.icStar0;
    } else if (star == 0.5) {
      return ResIcon.icStar05;
    } else if (star == 1.0) {
      return ResIcon.icStar1;
    } else if (star == 1.5) {
      return ResIcon.icStar15;
    } else if (star == 2.0) {
      return ResIcon.icStar2;
    } else if (star == 2.5) {
      return ResIcon.icStar25;
    } else if (star == 3.0) {
      return ResIcon.icStar3;
    } else {
      return ResIcon.icStar0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constants for layouts
    const double itemSize = 120.0;
    const double verticalSpacing = 120.0;
    const double initialTopOffset = 120.0;
    const double lineVerticalOffset = 220.0;
    const double extraHeight = 200.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth / 1.6;
    final leftSidePosition = 0.0;
    final rightSidePosition = contentWidth - itemSize;

    // Line positioning constants
    final leftLineHorizontalPosition = screenWidth / 7;
    final rightLineHorizontalPosition = screenWidth / 3.5;
    final lineWidth = screenWidth - (screenWidth / 7) * 2;
    const lineHeight = 70.0;

    // Tạo danh sách items theo thứ tự ngược
    final List<SongCollection> displayData = _campaignSongs.isNotEmpty ? _campaignSongs.reversed.toList() : [];

    // Tính toán tổng chiều cao cần thiết cho tất cả các mục
    final totalHeight = displayData.length * verticalSpacing + extraHeight;
    final provider = Provider.of<CampaignProvider>(context);

    return CustomScaffold(
      // backgroundType: BackgroundType.gradient,
      bottomNavigationBar: const SafeArea(child: CollapsibleBannerAdWidget(adName: "banner_collap_all")),
      backgroundImage: ResImage.imgBackgroundScreen,
      backgroundFit: BoxFit.cover,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 100,
        leading: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.maybePop(context);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 12),
              Icon(Icons.arrow_back_ios, size: 18),
              SizedBox(width: 4.0),
              Text(
                context.locale.back,
                style: TextStyle(fontSize: 17, fontWeight: AppFonts.regular),
              ),
            ],
          ),
        ),
        title: Text(
          context.locale.campaign,
          style: TextStyle(
            fontSize: 20,
            fontWeight: AppFonts.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? CupertinoActivityIndicator()
          : SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.zero,
        controller: _scrollController,
        child: Center(
          child: SizedBox(
            width: contentWidth,
            height: totalHeight,
            child: Stack(
              children: [
                /// Đường nối giữa các level
                ...List.generate(displayData.isNotEmpty ? displayData.length - 1 : 0, (index) {
                  final verticalPosition =
                      lineVerticalOffset + index * verticalSpacing;
                  final isEvenIndex = index % 2 == 0;
                  final svgPath = isEvenIndex
                      ? ResIcon.icLineLeft
                      : ResIcon.icLineRight;
                  final horizontalPosition = isEvenIndex
                      ? leftLineHorizontalPosition
                      : rightLineHorizontalPosition;

                  return Positioned(
                    top: verticalPosition,
                    left: horizontalPosition,
                    child: SvgPicture.asset(
                      svgPath,
                      width: lineWidth,
                      height: lineHeight,
                      fit: BoxFit.fill,
                    ),
                  );
                }),

                /// Các nút level
                ...List.generate(
                  displayData.isNotEmpty ? displayData.length : 0,
                      (index) {
                    final item = displayData[index];
                    final verticalPosition =
                        initialTopOffset + index * verticalSpacing;
                    final horizontalPosition = index % 2 == 0
                        ? leftSidePosition
                        : rightSidePosition;

                    return Positioned(
                      top: verticalPosition,
                      left: horizontalPosition,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          final actualIndex = displayData.length - (index + 1);
                          print('actualIndex: $actualIndex');
                          // Navigator.push(context, CupertinoPageRoute(builder: (context) => ResultScreen(perfectScore: 20, goodScore: 30, earlyScore: 20, lateScore: 10, missScore: 1),));
                          if(isUnlocked(provider, displayData.length, index)) {
                            provider.setCurrentSongCampaign(actualIndex);
                            await Navigator.push(context, CupertinoPageRoute(builder: (context) => LoadingDataScreen(
                              song: item,
                              callbackLoadingFailed: (){
                                Navigator.pop(context);
                              },
                              callbackLoadingCompleted: (song) async {
                                await Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => GamePlayScreen(
                                  songCollection: song,
                                  index: song.lessons.length - 1,
                                  isFromCampaign: true,
                                  onChangeCampaignStar: (star) async {
                                    print('change star index: ${displayData.length - provider.currentSongCampaign - 1} with $star');
                                    await updateStar(provider, displayData[displayData.length - provider.currentSongCampaign - 1], star);
                                  },
                                  onChangeUnlockedModeCampaign: () {
                                    provider.setUnlocked(difficult: widget.difficult ,value: provider.currentSongCampaign >= getUnlockedIndex(provider) ? provider.currentSongCampaign + 1 : getUnlockedIndex(provider));
                                  },
                                ),));
                                print('fetch data campaign');
                                await fetchData();
                              },
                            ),));
                          }
                        },
                        child: Container(
                          width: itemSize,
                          height: itemSize,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage( isUnlocked(provider, displayData.length, index) ?ResImage.imgBgButtonStepLessonUnlock
                                  : ResImage.imgBgButtonStepLesson),
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: isUnlocked(provider, displayData.length, index)
                              ? Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                context.locale.level,
                                style: TextStyle(
                                  fontWeight: AppFonts.semiBold,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${displayData.length - (index + 1) + 1}",
                                style: TextStyle(
                                  fontWeight: AppFonts.semiBold,
                                  fontSize: 36,
                                  color: Colors.white,
                                ),
                              ),
                              SvgPicture.asset(
                                _getStarIcon(item.campaignStar),
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ],
                          )
                              : Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: SvgPicture.asset(
                                ResIcon.icLock,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isUnlocked(CampaignProvider provider, int dataLength, int index){
    return getUnlockedIndex(provider) >= dataLength - (index + 1);
  }

  Future<void> updateStar(CampaignProvider provider, SongCollection song, double star) async {
    SongCollection updatedSong = (await provider.getSong(song.id)).copyWith(campaignStar: star);
    await provider.updateSong(song.id, updatedSong);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
