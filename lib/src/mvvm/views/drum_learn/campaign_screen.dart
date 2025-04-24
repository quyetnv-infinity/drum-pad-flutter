import 'package:ads_tracking_plugin/collapsible_banner_ad/collapsible_banner_ad_widget.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/purchase_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/campaign_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Consumer<PurchaseProvider>(
        builder: (context, purchaseProvider, _) {
          return !purchaseProvider.isSubscribed ? const SafeArea(child: CollapsibleBannerAdWidget(adName: "banner_collap_all")) : const SizedBox.shrink();
        }
      ),
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          leadingWidth: 100,
          toolbarHeight: 50,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                  Text(context.locale.back, style: TextStyle(color: Colors.white, fontSize: 17),)
                ],
              ),
            ),
          ),
          title: Text(context.locale.campaign, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),)
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CampaignItem(difficult: DifficultyMode.easy,),
              CampaignItem(difficult: DifficultyMode.medium),
              CampaignItem(difficult: DifficultyMode.hard),
              CampaignItem(difficult: DifficultyMode.demonic),
            ],
          ),
        )
      )
    );
  }
}
