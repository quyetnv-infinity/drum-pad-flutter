import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/utils/image_preloader.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/image/cached_image_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view/widget/star/star_result.dart';
import 'package:and_drum_pad_flutter/view_model/campaign_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CampaignDetailScreen extends StatefulWidget {
  final String difficulty;
  const CampaignDetailScreen({super.key, required this.difficulty});

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

const double contentWidth = 318.5840707964602;

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  // Constants
  static const double _itemSize = 56.0;
  static const double _extraHeight = 200.0;
  static const double _contentWidthDivisor = 1.13;
  static const double _verticalSpacingDivisor1 = 1.2;
  static const double _verticalSpacingDivisor2 = 1.5;
  static const double _leftLineHorizontalDivisor = 17.0;
  static const double _rightLineHorizontalDivisor = 15.0;
  static const double _itemPadding = 5.0;


  // Cache các giá trị tính toán để tránh rebuild
  late final double _verticalSpacing;
  late final double _leftSidePosition;
  late final double _rightSidePosition;
  late final double _leftLineHorizontalPosition;
  late final double _rightLineHorizontalPosition;

  // Preload state
  bool _imagesPreloaded = false;

  // Danh sách ảnh cần preload cho campaign detail
  static final List<String> _campaignImages = [
    ResImage.imgLineToRight,
    ResImage.imgLineToLeft,
    ResImage.imgLockLevel,
    "assets/images/img_bg_campaign_detail.png",
  ];

  @override
  void initState() {
    super.initState();
    _preloadCampaignImages();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CampaignProvider>(context, listen: false).fetchCampaignSong(
        isEasy: widget.difficulty == DifficultyMode.easy,
        isMedium: widget.difficulty == DifficultyMode.medium,
        isHard: widget.difficulty == DifficultyMode.hard,
        isDemonic: widget.difficulty == DifficultyMode.demonic,
      );
    });
  }

  // Preload ảnh sử dụng ImagePreloader
  Future<void> _preloadCampaignImages() async {
    try {
      await ImagePreloader.preloadImages(context, _campaignImages);
      if (mounted) {
        setState(() {
          _imagesPreloaded = true;
        });
      }
    } catch (e) {
      debugPrint('Error preloading campaign images: $e');
      // Vẫn cho phép hiển thị nếu preload thất bại
      if (mounted) {
        setState(() {
          _imagesPreloaded = true;
        });
      }
    }
  }

  @override
  void dispose() {
    // Cleanup khi không cần thiết
    // CachedImageWidget sẽ tự động manage cache
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _verticalSpacing = (contentWidth / _verticalSpacingDivisor1) / _verticalSpacingDivisor2;
    _leftSidePosition = 0.0;
    _rightSidePosition = contentWidth - (_itemSize + _itemPadding);
    _leftLineHorizontalPosition = contentWidth / _leftLineHorizontalDivisor;
    _rightLineHorizontalPosition = contentWidth / _rightLineHorizontalDivisor;
  }

  // Selector để chỉ rebuild khi campaign data thay đổi
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      imagePath: "assets/images/img_bg_campaign_detail.png",
      appBar: CustomAppBar(
        iconLeading: ResIcon.icClose,
        onTapLeading: () => Navigator.pop(context),
      ),
      body: !_imagesPreloaded
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Selector<CampaignProvider, List<SongCollection>>(
              selector: (context, provider) => _getSongsByDifficulty(provider),
              builder: (context, songs, child) {
                final reversedSongs = songs.reversed.toList();
                final totalHeight = reversedSongs.length * contentWidth / 2 + _extraHeight;

                return SingleChildScrollView(
                  reverse: true,
                  child: Center(
                    child: SizedBox(
                      width: contentWidth,
                      height: totalHeight,
                      child: _CampaignLevelMap(
                        songs: reversedSongs,
                        verticalSpacing: _verticalSpacing,
                        leftSidePosition: _leftSidePosition,
                        rightSidePosition: _rightSidePosition,
                        leftLineHorizontalPosition: _leftLineHorizontalPosition,
                        rightLineHorizontalPosition: _rightLineHorizontalPosition,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _CampaignLevelMap extends StatelessWidget {
  final List<SongCollection> songs;
  final double verticalSpacing;
  final double leftSidePosition;
  final double rightSidePosition;
  final double leftLineHorizontalPosition;
  final double rightLineHorizontalPosition;

  const _CampaignLevelMap({
    required this.songs,
    required this.verticalSpacing,
    required this.leftSidePosition,
    required this.rightSidePosition,
    required this.leftLineHorizontalPosition,
    required this.rightLineHorizontalPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Connecting lines
        ...List.generate(songs.isNotEmpty ? songs.length - 1 : 0, (index) {
          final lineVerticalPosition = (100.0 - index +5) + index * verticalSpacing;
          final isEvenIndex = (songs.length - index) % 2 == 1;

          return Positioned(
            top: lineVerticalPosition,
            left: isEvenIndex ? leftLineHorizontalPosition: rightLineHorizontalPosition,
            child: CachedImageWidget(
              imagePath: isEvenIndex ? ResImage.imgLineToRight : ResImage.imgLineToLeft,
              fit: BoxFit.contain,
            ),
          );
        }),



        // Level items
        ...List.generate(songs.length, (index) {
          final item = songs[index];
          final levelNumber = songs.length - index;
          final verticalPosition = (100 - index) + index * verticalSpacing;
          final horizontalPosition = (songs.length - index) % 2 == 1
              ? rightSidePosition
              : leftSidePosition;

          return Positioned(
            top: verticalPosition,
            left: horizontalPosition,
            child: _LevelItem(
              key: ValueKey('${item.id}_$levelNumber'),
              song: item,
              levelNumber: levelNumber,
            ),
          );
        }),
      ],
    );
  }
}

class _LevelItem extends StatelessWidget {
  final SongCollection song;
  final int levelNumber;

  const _LevelItem({
    super.key,
    required this.song,
    required this.levelNumber,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => print(song.name),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 56.0,
            height: 56.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CachedImageWidget(
                  imagePath: ResImage.imgLockLevel,
                  width: 56.0,
                  height: 56.0,
                  cacheWidth: 56,
                  cacheHeight: 56,
                  fit: BoxFit.cover,
                ),
                Text(
                  levelNumber.toString(),
                  style: const TextStyle(
                    color: Color(0xFF4E4337),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (song.campaignStar > 0)
            RatingStars.custom(
              value: song.campaignStar,
              smallStarWidth: 20,
              smallStarHeight: 20,
              bigStarWidth: 20,
              bigStarHeight: 20,
              isFlatStar: false,
            ),
        ],
      ),
    );
  }
}