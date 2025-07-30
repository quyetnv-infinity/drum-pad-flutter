import 'package:ads_tracking_plugin/collapsible_banner_ad/collapsible_banner_ad_widget.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/view/screen/campaign_detail/body/body.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/purchase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:and_drum_pad_flutter/config/ads_config.dart';

class CampaignDetailScreen extends StatelessWidget {
  final String difficulty;

  const CampaignDetailScreen({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {

    print('build CampaignDetailScreen - ${DateTime.now()}');

    return AppScaffold(
      imagePath: "assets/images/img_bg_campaign_detail.png",
      appBar: CustomAppBar(
        iconLeading: ResIcon.icClose,
        onTapLeading: () => Navigator.pop(context),
      ),
      bottomNavigationBar: Consumer<PurchaseProvider>(
        builder: (context, purchaseProvider, _) {
          return !purchaseProvider.isSubscribed
              ? SafeArea(
                  child: CollapsibleBannerAdWidget(adName: AdName.bannerCampaign),
                )
              : const SizedBox.shrink();
        },
      ),
      body: BodyCampaignDetail(difficulty: difficulty),
    );
  }
}
