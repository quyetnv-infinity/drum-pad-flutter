import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/widget/star/star_result.dart';
import 'package:flutter/material.dart';

class CampaignItem extends StatelessWidget {
  final Widget trailingWidget;
  final Widget name;
  final double score;
  final double star;
  const CampaignItem({super.key, required this.trailingWidget, required this.name, this.score = 0, this.star = 0});



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          spacing: 12,
          children: [
            Image.asset(ResImage.imgPads),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      name,
                      Text(
                        context.locale.score(score.toStringAsFixed(0)),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
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
    );
  }
}
