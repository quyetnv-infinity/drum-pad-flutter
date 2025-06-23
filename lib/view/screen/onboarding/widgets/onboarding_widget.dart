import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:base_ui_flutter_v1/base_ui_flutter_v1.dart';
import 'package:flutter/material.dart';

Widget customPage({required BuildContext context, required String backgroundAsset, required String title, required String subtitle, EdgeInsets? imagePadding}){
  return OnboardingItem(
    imageAsset: backgroundAsset,
    fit: BoxFit.cover,
    imagePadding: imagePadding ?? EdgeInsets.zero,
    title: Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16
        ),
      ),
    ),
    subTitle: Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
      child: Text(
        subtitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFCCCDD0),
          fontSize: 14
        )
      ),
    ),
  );
}

Widget page1(BuildContext context){
  return customPage(context: context, backgroundAsset: 'assets/images/onboarding_1.png', title: context.locale.title_onboarding_1, subtitle: context.locale.subtitle_onboarding_1, imagePadding: EdgeInsets.only(top: 56));
}

Widget page2(BuildContext context){
  return customPage(context: context, backgroundAsset: 'assets/images/onboarding_2.png', title: context.locale.title_onboarding_2, subtitle: context.locale.subtitle_onboarding_2);
}

Widget page3(BuildContext context){
  return customPage(context: context, backgroundAsset: 'assets/images/onboarding_3.png', title: context.locale.title_onboarding_3, subtitle: context.locale.subtitle_onboarding_3);
}

Widget page4(BuildContext context){
  return customPage(context: context, backgroundAsset: 'assets/images/onboarding_4.png', title: context.locale.title_onboarding_4, subtitle: context.locale.subtitle_onboarding_4, imagePadding: EdgeInsets.only(top: 56));
}
