import 'package:ads_tracking_plugin/native_ad/native_ad_widget.dart';
import 'package:and_drum_pad_flutter/config/ads_config.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/widget/pick_song_bottom_sheet.dart';
import 'package:and_drum_pad_flutter/view/screen/home/home_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/result/widget/congratulations_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/loading_dialog/loading_dialog.dart';
import 'package:and_drum_pad_flutter/view/widget/star/star_result.dart';
import 'package:and_drum_pad_flutter/view/widget/text/judgement_text.dart';
import 'package:and_drum_pad_flutter/view_model/app_state_provider.dart';
import 'package:and_drum_pad_flutter/view_model/campaign_provider.dart';
import 'package:and_drum_pad_flutter/view_model/result_information_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  final int perfectScore;
  final int goodScore;
  final int earlyScore;
  final int lateScore;
  final int missScore;
  final int totalScore;
  final int totalNotes;
  final bool isFromLearn;
  final bool isFromCampaign;
  final int currentLesson;
  final int maxLesson;
  final bool isCompleted;
  final bool isCompleteCampaign;

  const ResultScreen({
    super.key,
    required this.perfectScore,
    required this.goodScore,
    required this.earlyScore,
    required this.lateScore,
    required this.missScore, required this.totalScore, required this.totalNotes, required this.isFromLearn, required this.currentLesson, required this.maxLesson, required this.isFromCampaign, required this.isCompleted, required this.isCompleteCampaign,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  double _percentStar = 0;
  late bool isShowCongratulations;

  // Khởi tạo các biến cho animation
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _perfectPercentAnimation;
  late Animation<double> _goodPercentAnimation;
  late Animation<double> _earlyPercentAnimation;
  late Animation<double> _latePercentAnimation;
  late Animation<double> _missPercentAnimation;
  late Animation<double> _starAnimation;

  @override
  void initState() {
    print('15teiugdsfkjvc ${widget.totalNotes}');
    print('15teiugdsfkjvc ${widget.perfectScore}');
    print('15teiugdsfkjvc ${widget.goodScore}');
    print('15teiugdsfkjvc ${widget.lateScore}');
    print('15teiugdsfkjvc ${widget.earlyScore}');
    print('15teiugdsfkjvc ${widget.missScore}');
    print('scoreeeeee ${widget.totalScore}');
    super.initState();
    isShowCongratulations = widget.isCompleteCampaign && widget.isCompleted;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(isShowCongratulations) {
        showDialog(context: context, builder: (context) => CongratulationsWidget(
            onTapExit: () {
              Navigator.pop(context);
            },
          ),
        );
      }
    },);
    _calculateTotalNotes();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _setupAnimations();
    _animationController.forward();

    final provider = context.read<ResultInformationProvider>();
    provider.loadPoints();
    provider.addPoints(
      early: widget.earlyScore,
      good: widget.goodScore,
      late: widget.lateScore,
      perfect: widget.perfectScore,
      miss: widget.totalNotes - (widget.earlyScore + widget.goodScore + widget.lateScore + widget.perfectScore)
    );

  }

  void _calculateTotalNotes() {
    _percentStar = (widget.totalScore / (widget.totalNotes * 100)) * 100;
  }

  void _setupAnimations() {
    _scoreAnimation = Tween<double>(
      begin: 0,
      end: _totalScoreDisplay.toDouble(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _starAnimation = Tween<double>(
      begin: 0,
      end: _percentStar,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    // Animation cho phần trăm các thành phần
    int perfectPercent = (widget.perfectScore / widget.totalNotes * 100).floor();
    int goodPercent = (widget.goodScore / widget.totalNotes * 100).floor();
    int latePercent = (widget.lateScore / widget.totalNotes * 100).floor();
    int earlyPercent = (widget.earlyScore / widget.totalNotes * 100).floor();
    int missPercent = 100 - perfectPercent - goodPercent - latePercent - earlyPercent;
    if (missPercent == 1) {
      missPercent = 0;

      Map<String, int> scores = {
        'perfect': perfectPercent,
        'good': goodPercent,
        'late': latePercent,
        'early': earlyPercent,
      };

      String maxKey = scores.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

      switch (maxKey) {
        case 'perfect':
          perfectPercent += 1;
          break;
        case 'good':
          goodPercent += 1;
          break;
        case 'late':
          latePercent += 1;
          break;
        case 'early':
          earlyPercent += 1;
          break;
      }
    }
    _perfectPercentAnimation = _createPercentAnimation(perfectPercent);
    _goodPercentAnimation = _createPercentAnimation(goodPercent);
    _earlyPercentAnimation = _createPercentAnimation(earlyPercent);
    _latePercentAnimation = _createPercentAnimation(latePercent);
    _missPercentAnimation = _createPercentAnimation(missPercent);
  }

  Animation<double> _createPercentAnimation(int value) {
    return Tween<double>(
      begin: 0,
      end: value.toDouble(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));
  }

  int get _totalScoreDisplay {
    return widget.totalScore;
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.all(12).copyWith(top: 20, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: RadialGradient(colors: [Color(0xff33114d), Color(0xff7727b3)], center: Alignment.bottomCenter)
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, snapshot) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingStars.custom(value: _starAnimation.value, paddingMiddle: 20, smallStarWidth: 60, smallStarHeight: 60, bigStarWidth: 84, bigStarHeight: 84, isFlatStar: true, isPaddingBottom: true,),
                Text(!checkNotLastCampaign() ? context.locale.final_score : context.locale.score_string, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                Text(
                  "${_scoreAnimation.value.toInt()}",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700)
                ),
                SizedBox(height: 20),
                accuracyAllSongs(),
                SizedBox(height: 36),
                Row(
                  spacing: 8,
                  children: [
                    Opacity(
                      opacity: widget.isFromCampaign ? 0 : 1,
                      child: _buildIconButton(asset: ResIcon.icMusic,
                        onTap: () async {
                          if(widget.isFromCampaign) return;
                          final result = await showModalBottomSheet<SongCollection>(
                            isScrollControlled: true,
                            barrierColor: Colors.black.withValues(alpha: 0.8),
                            context: context,
                            builder: (context) => PickSongScreen(),
                          );
                          if(!widget.isFromCampaign && !widget.isFromLearn) {
                            Navigator.pop(context, result);
                          } else if(widget.isFromLearn) {
                            Navigator.pop(context, result);
                            Navigator.pop(context, result);
                          }
                        }),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if(!checkNotLastCampaign()) {
                            Navigator.pop(context, 'play_again');
                          } else {
                            if(widget.isFromLearn) {
                              Navigator.pop(context, widget.currentLesson + 1);
                              Navigator.pop(context, widget.currentLesson + 1);
                            }
                            if(widget.isFromCampaign) {
                              final campaignProvider = Provider.of<CampaignProvider>(context, listen: false);
                              final nextCampaignIndex = campaignProvider.currentSongCampaign + 1;
                              campaignProvider.setCurrentSongCampaign(nextCampaignIndex);
                              final song = campaignProvider.currentCampaign[nextCampaignIndex];
                              print('song ${song.name} with index $nextCampaignIndex');
                              Navigator.pop(context);
                              Navigator.pop(context);
                              // showDialog(
                              //   context: context,
                              //   builder: (context) => LoadingDataScreen(
                              //     callbackLoadingCompleted: (songResult) {
                              //       Navigator.pop(context, songResult);
                              //       Navigator.pop(context, songResult);
                              //     },
                              //     callbackLoadingFailed: () {
                              //       Navigator.pop(context);
                              //       Navigator.pop(context);
                              //     },
                              //     song: song
                              //   ),
                              // );
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(colors: [Color(0xffa005ff), Color(0xffd796ff)])
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 8,
                            children: [
                              if(!checkNotLastCampaign())
                              SvgPicture.asset(ResIcon.icRefresh),

                              Text(!checkNotLastCampaign() ? context.locale.play_again : context.locale.continue_text, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16), textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildIconButton(asset: ResIcon.icHome,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false,);
                      }
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Consumer<AppStateProvider>(builder: (context, value, child) {
                  return NativeAdWidget(
                    adName:!checkNotLastCampaign() ? AdName.nativePopupPlayDone : AdName.nativePopupPause,
                    disabled: !value.shouldShowAds,
                    onAdLoaded: (value) {
                      print("Native ad loaded: $value");
                    },
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(width: 1, color: Color(0xFFD3D3D3))
                    ),
                  );
                },),
              ],

            );
          }
        )),
    );
  }
  Widget _buildIconButton({required String asset, required Function() onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xffc84bff).withValues(alpha: 0.1)
        ),
        child: SvgPicture.asset(asset)
      ),
    );
  }

  Widget accuracyAllSongs() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withValues(alpha: 0.1)
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4).copyWith(left: 32),
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
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// perfect
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(_perfectPercentAnimation.value.toStringAsFixed(0).toString(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, fontFamily: AppFonts.sigmar, color: Colors.white, height: 0.9),),
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
                      Text(_goodPercentAnimation.value.toStringAsFixed(0).toString(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, fontFamily: AppFonts.sigmar, color: Colors.white, height: 0.9),),
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
                      Text(_earlyPercentAnimation.value.toStringAsFixed(0).toString(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, fontFamily: AppFonts.sigmar, color: Colors.white, height: 0.9),),
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
                      Text(_latePercentAnimation.value.toStringAsFixed(0).toString(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, fontFamily: AppFonts.sigmar, color: Colors.white, height: 0.9),),
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
                      Text(_missPercentAnimation.value.toStringAsFixed(0).toString(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, fontFamily: AppFonts.sigmar, color: Colors.white, height: 0.9),),
                      Text('%', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, fontFamily: AppFonts.sigmar, color: Colors.white),),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  bool checkNotLastCampaign(){
    if(widget.isFromLearn){
      return widget.currentLesson < widget.maxLesson - 1 && widget.isCompleted;
    } else if(widget.isFromCampaign) {
      final campaignProvider = Provider.of<CampaignProvider>(context, listen: false);
      return campaignProvider.currentSongCampaign < campaignProvider.currentCampaign.length - 1 && widget.isCompleted;
    }
    return false;
  }

}
