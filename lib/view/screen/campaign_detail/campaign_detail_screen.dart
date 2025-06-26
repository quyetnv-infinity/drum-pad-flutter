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

// Constants class để chia sẻ giữa các widgets
class _CampaignConstants {
  static const double itemSize = 56.0;
  static const double extraHeight = 200.0;
  static const double contentWidth = 318.5840707964602;
  static const double itemPadding = 5.0;
  static const double verticalSpacingDivisor1 = 1.2;
  static const double verticalSpacingDivisor2 = 1.5;
  static const double leftLineHorizontalDivisor = 17.0;
  static const double rightLineHorizontalDivisor = 15.0;

  // Content-width based calculations
  static const double verticalSpacing = (contentWidth / verticalSpacingDivisor1) / verticalSpacingDivisor2;
  static const double leftSidePosition = 0.0;
  static const double rightSidePosition = contentWidth - (itemSize + itemPadding);
  static const double leftLineHorizontalPosition = contentWidth / leftLineHorizontalDivisor;
  static const double rightLineHorizontalPosition = contentWidth / rightLineHorizontalDivisor;

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
  // Loading states
  bool _imagesPreloaded = false;
  bool _dataLoaded = false;
  List<SongCollection> _currentSongs = [];

  // Danh sách ảnh cần preload cho campaign detail
  static final List<String> _campaignImages = [
    ResImage.imgLineToRight,
    ResImage.imgLineToLeft,
    ResImage.imgLockLevel,
    "assets/images/img_bg_campaign_detail.png",
    ResImage.img1,
    ResImage.img2,
    ResImage.img3,
    ResImage.img4,
    ResImage.img5,
    ResImage.img6,
  ];

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  // Khởi tạo đồng thời cả data và ảnh
  Future<void> _initializeScreen() async {
    // Khởi tạo đồng thời
    await Future.wait([
      _preloadCampaignImages(),
      _loadCampaignData(),
    ]);
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

  // Load campaign data
  Future<void> _loadCampaignData() async {
    try {
      final provider = Provider.of<CampaignProvider>(context, listen: false);

      // Fetch data
      await provider.fetchCampaignSong(
        isEasy: widget.difficulty == DifficultyMode.easy,
        isMedium: widget.difficulty == DifficultyMode.medium,
        isHard: widget.difficulty == DifficultyMode.hard,
        isDemonic: widget.difficulty == DifficultyMode.demonic,
      );

      // Lấy data sau khi load xong
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
          _dataLoaded = true; // Vẫn cho phép hiển thị với data rỗng
        });
      }
    }
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

  // Check xem đã ready để hiển thị chưa
  bool get _isReadyToShow => _imagesPreloaded && _dataLoaded;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      imagePath: "assets/images/img_bg_campaign_detail.png",
      appBar: CustomAppBar(
        iconLeading: ResIcon.icClose,
        onTapLeading: () => Navigator.pop(context),
      ),
      body: !_isReadyToShow
          ? _buildLoadingWidget()
          : _buildCampaignContent(),
    );
  }

  // Widget hiển thị loading
  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Loading campaign...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị nội dung campaign
  Widget _buildCampaignContent() {
    // Sử dụng Consumer để theo dõi thay đổi data real-time
    return Consumer<CampaignProvider>(
      builder: (context, provider, child) {
        // Cập nhật songs từ provider nếu có thay đổi
        final latestSongs = _getSongsByDifficulty(provider);
        final songsToDisplay = latestSongs.isNotEmpty ? latestSongs : _currentSongs;

        final reversedSongs = songsToDisplay.reversed.toList();
        final totalHeight = reversedSongs.length * _CampaignConstants.contentWidth / 2 + _CampaignConstants.extraHeight;

        return SingleChildScrollView(
          reverse: true,
          child: Center(
            child: SizedBox(
              width: _CampaignConstants.contentWidth,
              height: totalHeight,
              child: _CampaignLevelMap(
                songs: reversedSongs,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Cleanup khi không cần thiết
    super.dispose();
  }
}

class _CampaignLevelMap extends StatelessWidget {
  final List<SongCollection> songs;

  const _CampaignLevelMap({
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    const double lineOffsetIncrement = 5.0;

    List<double> levelPositions = List.generate(songs.length, (index) {
      return (100.0 - index.toDouble()) + index * _CampaignConstants.verticalSpacing;
    });

    double getLevelPosition(int level) {
      int index = songs.length - level;
      if (index >= 0 && index < songs.length) {
        return levelPositions[index].toDouble();
      }
      return 0.0;
    }

    final double img6Position = songs.length >= 2 ? getLevelPosition(2) : 0.0;
    final double img1Position = songs.length >= 3 ? getLevelPosition(3) : 0.0;
    final double img2Position = songs.length >= 4 ? getLevelPosition(4) : 0.0;
    final double img3Position = songs.length >= 5 ? getLevelPosition(5) : 0.0;
    final double img5Position = songs.length >= 6 ? getLevelPosition(6) : 0.0;
    final double img4Position = songs.length >= 6 ? getLevelPosition(7) : 0.0;

    return Stack(
      children: [
        // Connecting lines
        ...List.generate(songs.isNotEmpty ? songs.length - 1 : 0, (index) {
          final double lineVerticalPosition = (100.0 - index + 5.0) + index * _CampaignConstants.verticalSpacing + (index * lineOffsetIncrement);
          final bool isEvenIndex = (songs.length - index) % 2 == 1;

          return Positioned(
            top: lineVerticalPosition,
            left: isEvenIndex
                ? _CampaignConstants.leftLineHorizontalPosition
                : _CampaignConstants.rightLineHorizontalPosition,
            child: CachedImageWidget(
              imagePath: isEvenIndex ? ResImage.imgLineToRight : ResImage.imgLineToLeft,
              fit: BoxFit.contain,
            ),
          );
        }),

        ...List.generate(songs.length, (index) {
          final item = songs[index];
          final levelNumber = songs.length - index;
          final double verticalPosition = levelPositions[index];
          final double horizontalPosition = (songs.length - index) % 2 == 1
              ? _CampaignConstants.rightSidePosition
              : _CampaignConstants.leftSidePosition;

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

        // Image 6: Opposite level 2, requires levels 1 and 2
        if (songs.length >= 2)
          Positioned(
            top: img6Position,
            right: 0,
            child: CachedImageWidget(
              imagePath: ResImage.img6,
              width: 150.0,
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),

        // Image 1: Opposite level 3, requires levels 1, 2, 3
        if (songs.length >= 3)
          Positioned(
            top: img1Position,
            left: 0,
            child: CachedImageWidget(
              imagePath: ResImage.img1,
              width: 150.0,
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),

        // Image 2: Opposite level 4, requires levels 1, 2, 3, 4
        if (songs.length >= 4)
          Positioned(
            top: img2Position,
            right: 0,
            child: CachedImageWidget(
              imagePath: ResImage.img2,
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),

        // Image 3: Opposite level 5, requires levels 1, 2, 3, 4, 5
        if (songs.length >= 5)
          Positioned(
            top: img3Position,
            left: 0,
            child: CachedImageWidget(
              imagePath: ResImage.img3,
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),

        // Image 5: Opposite level 6, requires levels 1, 2, 3, 4, 5, 6
        if (songs.length >= 6)
          Positioned(
            top: img5Position,
            right: 0,
            child: CachedImageWidget(
              imagePath: ResImage.img5,
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),

        // Image 4: Opposite level 7, requires levels 1, 2, 3, 4, 5, 6
        if (songs.length >= 6)
          Positioned(
            top: img4Position,
            left: 0,
            child: CachedImageWidget(
              imagePath: ResImage.img4,
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),
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
            width: _CampaignConstants.itemSize,
            height: _CampaignConstants.itemSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CachedImageWidget(
                  imagePath: ResImage.imgLockLevel,
                  width: _CampaignConstants.itemSize,
                  height: _CampaignConstants.itemSize,
                  cacheWidth: _CampaignConstants.itemSize.toInt(),
                  cacheHeight: _CampaignConstants.itemSize.toInt(),
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