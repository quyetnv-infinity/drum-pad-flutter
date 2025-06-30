import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/image_preloader.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/image/cached_image_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view/widget/star/star_result.dart';
import 'package:and_drum_pad_flutter/view_model/campaign_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Constants class để chia sẻ giữa các widgets
class _CampaignConstants {
  static const double contentWidth = 250;
  static const radioLine = 274 / 244; // Tỷ lệ chiều rộng so với chiều cao
  static const List<String> images = [
    ResImage.img1,
    ResImage.img2,
    ResImage.img3,
    ResImage.img4,
    ResImage.img5,
  ];
}

class CampaignDetailScreen extends StatefulWidget {
  final String difficulty;

  const CampaignDetailScreen({super.key, required this.difficulty});

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  bool _dataLoaded = false;
  List<SongCollection> _currentSongs = [];

  @override
  void initState() {
    super.initState();
    _loadCampaignData();
  }

  Future<void> _loadCampaignData() async {
    try {
      final provider = Provider.of<CampaignProvider>(context, listen: false);
      await provider.fetchCampaignSong(
        isEasy: widget.difficulty == DifficultyMode.easy,
        isMedium: widget.difficulty == DifficultyMode.medium,
        isHard: widget.difficulty == DifficultyMode.hard,
        isDemonic: widget.difficulty == DifficultyMode.demonic,
      );

      final songs = _getSongsByDifficulty(provider);

      if (mounted) {
        setState(() {
          _currentSongs = songs;
          _dataLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading campaign data: $e');
      if (mounted) {
        setState(() {
          _dataLoaded = true;
        });
      }
    }
  }

  List<SongCollection> _getSongsByDifficulty(CampaignProvider provider) {
    switch (widget.difficulty) {
      case DifficultyMode.easy:
        return provider.easyCampaign;
      case DifficultyMode.medium:
        return provider.mediumCampaign;
      case DifficultyMode.hard:
        return provider.hardCampaign;
      case DifficultyMode.demonic:
        return provider.demonicCampaign;
      default:
        return [];
    }
  }

  void _handleSelectLevel(SongCollection song) {
    // Handle level selection logic here
    print("Selected level: ${song.name}");
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      imagePath: "assets/images/img_bg_campaign_detail.png",
      appBar: CustomAppBar(
        iconLeading: ResIcon.icClose,
        onTapLeading: () => Navigator.pop(context),
      ),
      body: Center(child: _buildCampaignContent(),),
    );
  }

  Widget _getImage(int index, int maxLength) {
    int position = maxLength - index;

    if (position == 7) {
      return Positioned(
        top: -20,
        left: -20,
        child: Image.asset(
          ResImage.img4,
          width: 80,
          height: 80,
        ),
      );
    } else if (position == 6) {
      return Positioned(
        top: -20,
        right: -20,
        child: Image.asset(
          ResImage.img5,
          width: 80,
          height: 80,
        ),
      );
    } else if (position == 5) {
      return Positioned(
        top: -20,
        left: -20,
        child: Image.asset(
          ResImage.img3,
          width: 80,
          height: 80,
        ),
      );
    } else if (position == 4) {
      return Positioned(
        top: -20,
        right: -20,
        child: Image.asset(
          ResImage.img2,
          width: 80,
          height: 80,
        ),
      );
    } else if (position == 3) {
      return Positioned(
        top: -20,
        left: -20,
        child: Image.asset(
          ResImage.img1,
          width: 130,
          height: 130,
        ),
      );
    } else if (position == 2) {
      return Positioned(
        top: -20,
        right: -20,
        child: Image.asset(
          ResImage.img6,
          width: 100,
          height: 100,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildItemLevel(int level){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(ResImage.imgLockLevel),),
          ),
          alignment: Alignment.center,
          child: Text("$level", style: TextStyle(
            fontFamily: AppFonts.commando,
            fontWeight: FontWeight.normal,
            color: Color(0xFF4E4337),
            fontSize: 20,
          ),),
        ),
        Transform.translate(offset: Offset(0, -12), child: RatingStars.custom(value: 100, paddingMiddle: 20, smallStarWidth: 20, smallStarHeight: 20, bigStarWidth: 20, bigStarHeight: 20, isFlatStar: true, isPaddingBottom: false,)),
      ],
    );
  }

  Widget _buildCampaignContent() {
    return Consumer<CampaignProvider>(
      builder: (context, provider, child) {
        final latestSongs = _getSongsByDifficulty(provider);
        final songsToDisplay = latestSongs.isNotEmpty ? latestSongs : _currentSongs;
        final reversedSongs = songsToDisplay.reversed.toList();
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: _CampaignConstants.contentWidth,
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            reverse: true,
            child: Transform.translate(
              offset: Offset(0, 100),
              child: Column(
                children: List.generate(reversedSongs.length, (index) {
                  return Transform.translate(
                    offset: Offset(0, -(30 * index).toDouble()),
                    child: Container(
                      width: _CampaignConstants.contentWidth,
                      height: index < reversedSongs.length -1 ?  _CampaignConstants.contentWidth / _CampaignConstants.radioLine : 80,
                      decoration: BoxDecoration(
                        image: index < reversedSongs.length - 1 ? DecorationImage(
                          image: AssetImage((reversedSongs.length - index) % 2 == 0 ? ResImage.imgLineToLeft : ResImage.imgLineToRight),
                          fit: BoxFit.contain,
                        ) : null,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          if((reversedSongs.length - index) % 2 == 0 )
                            Positioned(
                              top: -16,
                              left: -27,
                              child: GestureDetector(
                                onTap: () => _handleSelectLevel(reversedSongs[index]),
                                child: _buildItemLevel(reversedSongs.length - index),
                              ),
                            ),

                          if((reversedSongs.length - index) % 2 == 1 )
                            Positioned(
                              top: -20,
                              right: -27,
                              child: GestureDetector(
                                onTap: () => _handleSelectLevel(reversedSongs[index]),
                                child: _buildItemLevel(reversedSongs.length - index),
                              ),
                            ),

                          _getImage(index, reversedSongs.length),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
