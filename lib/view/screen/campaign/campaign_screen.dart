import 'dart:ui';

import 'package:and_drum_pad_flutter/core/res/dimen/spacing.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/utils/calculate_func.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/campaign_detail/campaign_detail_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/list_item/campaign_item.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/campaign_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CampaignScreen extends StatelessWidget {
  const CampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        iconLeading: ResIcon.icBack,
        onTapLeading: () {
          Navigator.pop(context);
        },
        title: context.locale.campaign,
      ),
      body: SingleChildScrollView(
        child: Consumer<CampaignProvider>(
          builder: (context, value, child) {
            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              separatorBuilder: (context, index) => ResSpacing.h8,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.campaigns.length,
              itemBuilder: (context, index) {
                final campaign = value.campaigns[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CampaignDetailScreen(difficulty: campaign.difficulty,),),);
                  },
                  child: CampaignItem(
                    name: Row(
                      spacing: 8,
                      children: [
                        Text(
                          DifficultyMode.getCampaignName( context, campaign.difficulty),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Text(
                              DifficultyMode.getString(context, campaign.difficulty),
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    score: CalculateFunc.sumScore(campaign.data.map((e) => e.campaignScore,).toList()),
                    star: CalculateFunc.avgStar(campaign.data.map((e) => e.campaignStar,).toList()),
                    trailingWidget: SvgPicture.asset(ResIcon.icOvalArrowRight),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
