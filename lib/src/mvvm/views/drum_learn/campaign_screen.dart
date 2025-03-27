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
    Widget _getStarIcon(double percent) {
      if (percent < 15) {
        return Row(
          children: [
            SvgPicture.asset(ResIcon.starNull),
            SvgPicture.asset(ResIcon.starNull),
            SvgPicture.asset(ResIcon.starNull),
          ],
        );
      } else if (percent < 30) {
        return Row(
          children: [
            SvgPicture.asset(ResIcon.starHalf),
            SvgPicture.asset(ResIcon.starNull),
            SvgPicture.asset(ResIcon.starNull),
          ],
        );
      } else if (percent < 45) {
        return Row(
          children: [
            SvgPicture.asset(ResIcon.starFull),
            SvgPicture.asset(ResIcon.starNull),
            SvgPicture.asset(ResIcon.starNull),
          ],
        );
      } else if (percent < 60) {
        return Row(
          children: [
            SvgPicture.asset(ResIcon.starFull),
            SvgPicture.asset(ResIcon.starHalf),
            SvgPicture.asset(ResIcon.starNull),
          ],
        );
      } else if (percent < 75) {
        return Row(
          children: [
            SvgPicture.asset(ResIcon.starFull),
            SvgPicture.asset(ResIcon.starFull),
            SvgPicture.asset(ResIcon.starNull),
          ],
        );
      } else if (percent < 90) {
        return Row(
          children: [
            SvgPicture.asset(ResIcon.starFull),
            SvgPicture.asset(ResIcon.starFull),
            SvgPicture.asset(ResIcon.starHalf),
          ],
        );
      } else {
        return Row(children: [
          SvgPicture.asset(ResIcon.starFull),
          SvgPicture.asset(ResIcon.starFull),
          SvgPicture.asset(ResIcon.starFull)
        ]);
      }
    }

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
              CampaignItem(star: _getStarIcon(5),),
              CampaignItem(star: _getStarIcon(29),),
              CampaignItem(star: _getStarIcon(44),),
              CampaignItem(star: _getStarIcon(55),),
              CampaignItem(star: _getStarIcon(74),),
              CampaignItem(star: _getStarIcon(89),),
              CampaignItem(star: _getStarIcon(90),),
            ],
          ),
        )
      )
    );
  }
}
