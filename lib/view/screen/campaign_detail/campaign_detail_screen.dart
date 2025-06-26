import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
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

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  // Constants
  static const double _itemSize = 56.0;
  static const double _lineVerticalOffset = 115.0;
  static const double _initialTopOffset = 110.0;
  static const double _extraHeight = 200.0;
  static const double _contentWidthDivisor = 1.13;
  static const double _verticalSpacingDivisor1 = 1.2;
  static const double _verticalSpacingDivisor2 = 1.5;
  static const double _leftLineHorizontalDivisor = 17.0;
  static const double _rightLineHorizontalDivisor = 15.0;
  static const double _itemPadding = 5.0;

  // Cache các giá trị tính toán để tránh rebuild
  late final double _screenWidth;
  late final double _contentWidth;
  late final double _verticalSpacing;
  late final double _leftSidePosition;
  late final double _rightSidePosition;
  late final double _leftLineHorizontalPosition;
  late final double _rightLineHorizontalPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CampaignProvider>(context, listen: false).fetchCampaignSong(
        isEasy: widget.difficulty == DifficultyMode.easy,
        isMedium: widget.difficulty == DifficultyMode.medium,
        isHard: widget.difficulty == DifficultyMode.hard,
        isDemonic: widget.difficulty == DifficultyMode.demonic,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Tính toán và cache các giá trị chỉ một lần
    _screenWidth = MediaQuery.of(context).size.width;
    _contentWidth = _screenWidth / _contentWidthDivisor;
    _verticalSpacing = (_screenWidth / _verticalSpacingDivisor1) / _verticalSpacingDivisor2;
    _leftSidePosition = 0.0;
    _rightSidePosition = _contentWidth - (_itemSize + _itemPadding);
    _leftLineHorizontalPosition = _screenWidth / _leftLineHorizontalDivisor;
    _rightLineHorizontalPosition = _screenWidth / _rightLineHorizontalDivisor;
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
      body: Selector<CampaignProvider, List<SongCollection>>(
        selector: (context, provider) => _getSongsByDifficulty(provider),
        builder: (context, songs, child) {
          final reversedSongs = songs.reversed.toList();
          final totalHeight = reversedSongs.length * _screenWidth / 2 + _extraHeight;

          return SingleChildScrollView(
            reverse: true,
            child: Center(
              child: SizedBox(
                width: _contentWidth,
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

// Widget riêng biệt cho campaign map để tối ưu rebuild
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
          final lineVerticalPosition = 115.0 + index * verticalSpacing + 5;
          final isEvenIndex = (songs.length - index) % 2 == 1;

          return Positioned(
            top: lineVerticalPosition,
            left: isEvenIndex ? leftLineHorizontalPosition : rightLineHorizontalPosition,
            child: Image.asset(
              isEvenIndex ? ResImage.imgLineToRight : ResImage.imgLineToLeft,
            ),
          );
        }),

        // Level items
        ...List.generate(songs.length, (index) {
          final item = songs[index];
          final levelNumber = songs.length - index;
          final verticalPosition = 110.0 + index * verticalSpacing;
          final horizontalPosition = (songs.length - index) % 2 == 1
              ? rightSidePosition
              : leftSidePosition;

          return Positioned(
            top: verticalPosition,
            left: horizontalPosition,
            child: _LevelItem(
              key: ValueKey('${item.id}_$levelNumber'), // Key để tối ưu rebuild
              song: item,
              levelNumber: levelNumber,
            ),
          );
        }),
      ],
    );
  }
}

// Widget riêng cho từng level item với key để tối ưu
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
          Container(
            width: 56.0,
            height: 56.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ResImage.imgLockLevel),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              levelNumber.toString(),
              style: const TextStyle(
                color: Color(0xFF4E4337),
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
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