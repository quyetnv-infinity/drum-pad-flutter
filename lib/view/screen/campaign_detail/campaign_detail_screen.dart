import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/utils/calculate_func.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/campaign_model.dart';
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

  @override
  void initState() {
    // TODO: implement initState
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
  Widget build(BuildContext context) {

    const double itemSize = 56.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = screenWidth / 1.13;
    const double lineVerticalOffset = 115.0;
    final double verticalSpacing = (screenWidth / 1.2 ) / 1.5;
    const double initialTopOffset = 110.0;
    const double extraHeight = 200.0;
    final leftSidePosition = 0.0;
    final rightSidePosition = contentWidth - (itemSize + 5);

    final leftLineHorizontalPosition = screenWidth / 17;
    final rightLineHorizontalPosition = screenWidth / 15;

    return AppScaffold(
      imagePath: "assets/images/img_bg_campaign_detail.png",
      appBar: CustomAppBar(
        iconLeading: ResIcon.icClose,
        onTapLeading: () {
          Navigator.pop(context);
        },
      ),
      body: Consumer<CampaignProvider>(builder: (context, value, child) {
        List<SongCollection> songs = [];
        if (widget.difficulty == DifficultyMode.easy) {
          songs = value.easyCampaign;
        } else if (widget.difficulty == DifficultyMode.medium) {
          songs = value.mediumCampaign;
        } else if (widget.difficulty == DifficultyMode.hard) {
          songs = value.hardCampaign;
        } else if (widget.difficulty == DifficultyMode.demonic) {
          songs = value.demonicCampaign;
        }

        songs = songs.reversed.toList();

        double totalHeight = songs.length * screenWidth / 2+ extraHeight;

        return  SingleChildScrollView(
          reverse: true,
          child: Center(
            child: SizedBox(
              width: contentWidth,
              height: totalHeight,
              child: Stack(
                children: [
                  ...List.generate(songs.isNotEmpty ? songs.length - 1 : 0, (index) {
                    final leftLineVerticalPosition = lineVerticalOffset + index * verticalSpacing + 5;
                    final rightLineVerticalPosition = lineVerticalOffset + index * verticalSpacing + 5;
                    final verticalPosition = (songs.length - index) % 2 == 1
                        ? leftLineVerticalPosition
                        : rightLineVerticalPosition;
                    final isEvenIndex = (songs.length - index) % 2 == 1;
                    final path = isEvenIndex
                        ? ResImage.imgLineToRight
                        : ResImage.imgLineToLeft;
                    final horizontalPosition = isEvenIndex
                        ? leftLineHorizontalPosition
                        : rightLineHorizontalPosition;
                    return Positioned(
                      top: verticalPosition,
                      left: horizontalPosition,
                      child: Image.asset(path),
                    );
                  }),
                  ...List.generate(
                      songs.length,
                      (index) {
                        final item = songs[index];
                        double verticalPosition = initialTopOffset + index * verticalSpacing;
                        final horizontalPosition = (songs.length - index) % 2 == 1
                            ? rightSidePosition
                            : leftSidePosition;
                        return Positioned(
                          top: verticalPosition,
                          left: horizontalPosition,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              print(item.name);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: itemSize,
                                  height: itemSize,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage(ResImage.imgLockLevel)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${songs.length - index}",
                                    style: TextStyle(
                                      color: Color(0xFF4E4337),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                if(item.campaignStar > 0)
                                  RatingStars.custom(
                                    value: item.campaignStar,
                                    smallStarWidth: 20,
                                    smallStarHeight: 20,
                                    bigStarWidth: 20,
                                    bigStarHeight: 20,
                                    isFlatStar: false,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
              ),
            ),
          ),
        );
      },),
    );
  }
}
