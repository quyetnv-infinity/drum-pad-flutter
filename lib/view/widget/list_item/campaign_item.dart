import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/widget/star/star_result.dart';
import 'package:and_drum_pad_flutter/view/widget/image/cached_image_widget.dart';
import 'package:and_drum_pad_flutter/view_model/campaign_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CampaignItem extends StatefulWidget {
  final Widget trailingWidget;
  final Widget name;
  final double score;
  final double star;
  final int? levelIndex;
  
  const CampaignItem({
    super.key, 
    required this.trailingWidget, 
    required this.name, 
    this.score = 0, 
    this.star = 0, this.levelIndex
  });

  @override
  State<CampaignItem> createState() => _CampaignItemState();
}

class _CampaignItemState extends State<CampaignItem> {

  @override
  void initState() {
    super.initState();
    loadCampaign();
  }

  Future<void> loadCampaign() async {
    if(widget.levelIndex == null) return;
    final provider = Provider.of<CampaignProvider>(context, listen: false);
    provider.fetchCampaignSong(
      isEasy: widget.levelIndex == 0,
      isMedium: widget.levelIndex == 1,
      isHard: widget.levelIndex == 2,
      isDemonic: widget.levelIndex == 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicHeight(
          child: Row(
            spacing: 12,
            children: [
              CachedImageWidget(
                imagePath: ResImage.imgPads,
                width: 60,
                height: 80,
                fit: BoxFit.cover,
                cacheWidth: 120,
                cacheHeight: 120,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.name,
                        const SizedBox(height: 4),
                        Text(
                          context.locale.score(widget.score.toStringAsFixed(0)),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(255, 255, 255, 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingStars.custom(
                          value: widget.star,
                          smallStarWidth: 20,
                          smallStarHeight: 20,
                          bigStarWidth: 20,
                          bigStarHeight: 20,
                          isFlatStar: true,
                        ),
                        widget.trailingWidget,
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
