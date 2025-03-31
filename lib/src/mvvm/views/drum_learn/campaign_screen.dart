import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/campaign_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CampaignScreen extends StatelessWidget {
  const CampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              CampaignItem(percent: 5,),
              CampaignItem(percent: 29,),
              CampaignItem(percent: 44),
              CampaignItem(percent: 55,),
              CampaignItem(percent: 74,),
              CampaignItem(percent: 89,),
              CampaignItem(percent: 90,),
            ],
          ),
        )
      )
    );
  }
}
