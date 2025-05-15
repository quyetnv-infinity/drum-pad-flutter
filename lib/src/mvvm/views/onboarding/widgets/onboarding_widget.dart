import 'package:base_ui_flutter_v1/base_ui_flutter_v1.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';

Widget customPage({required BuildContext context, required String backgroundAsset, required String title, required String subtitle}){
  return ItemOnboarding(
    imageAsset: backgroundAsset,
    fit: BoxFit.cover,
    paddingImage: EdgeInsets.zero,
    title: Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFF8FAFC),
          fontWeight: FontWeight.w600,
          fontSize: 24
        ),
      ),
    ),
    subTitle: Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Text(
        subtitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFCBD5E1),
          fontSize: 16
        )
      ),
    ),
  );
}

Widget page1(BuildContext context){
  return customPage(context: context, backgroundAsset: 'assets/images/onboarding_1.png', title: context.locale.title_onboarding_1, subtitle: context.locale.subtitle_onboarding_1);
}

Widget page2(BuildContext context){
  return customPage(context: context, backgroundAsset: 'assets/images/onboarding_2.png', title: context.locale.title_onboarding_2, subtitle: context.locale.subtitle_onboarding_2);
}

Widget page3(BuildContext context){
  return customPage(context: context, backgroundAsset: 'assets/images/onboarding_3.png', title: context.locale.title_onboarding_3, subtitle: context.locale.subtitle_onboarding_3);
}

Widget page4(BuildContext context){
  return customPage(context: context, backgroundAsset: 'assets/images/onboarding_4.png', title: context.locale.title_onboarding_4, subtitle: context.locale.subtitle_onboarding_4);
}
