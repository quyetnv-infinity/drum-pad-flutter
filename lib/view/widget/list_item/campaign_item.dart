import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/widget/star/star_result.dart';
import 'package:and_drum_pad_flutter/view/widget/image/cached_image_widget.dart';
import 'package:and_drum_pad_flutter/core/mixins/optimized_widget_mixin.dart';
import 'package:flutter/material.dart';

class CampaignItem extends StatelessWidget with OptimizedWidgetMixin {
  final Widget trailingWidget;
  final Widget name;
  final double score;
  final double star;
  
  const CampaignItem({
    super.key, 
    required this.trailingWidget, 
    required this.name, 
    this.score = 0, 
    this.star = 0
  });



  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: getCachedEdgeInsets(all: 16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: getCachedBorderRadius(12),
        ),
        child: IntrinsicHeight(
          child: Row(
            spacing: 12,
            children: [
              // Sử dụng cached image widget để tối ưu hiệu suất
              CachedImageWidget(
                imagePath: ResImage.imgPads,
                width: 60,
                height: 60,
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
                        name,
                        const SizedBox(height: 4),
                        Text(
                          context.locale.score(score.toStringAsFixed(0)),
                          style: getCachedTextStyle(
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
                          value: star,
                          smallStarWidth: 20,
                          smallStarHeight: 20,
                          bigStarWidth: 20,
                          bigStarHeight: 20,
                          isFlatStar: true,
                        ),
                        trailingWidget,
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
