import 'package:ads_tracking_plugin/onboarding/base_onboarding_view.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';

Widget page1(BuildContext context){
  return OnboardingPage(
    backgroundImage: 'assets/images/onboarding_1.png',
    title: Text(context.locale.title_onboarding_1, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFF8FAFC)),),
    subTitle: Text(context.locale.subtitle_onboarding_1, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFFCBD5E1),), textAlign: TextAlign.center,),
    imageScale: 1,
    backgroundColor: Colors.transparent,
  );
}

Widget page2(BuildContext context){
  return OnboardingPage(
    backgroundImage: 'assets/images/onboarding_2.png',
    title: Text(context.locale.title_onboarding_2, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFF8FAFC)),),
    subTitle: Text(context.locale.subtitle_onboarding_2, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFFCBD5E1),), textAlign: TextAlign.center,),
    imageScale: 1,
    backgroundColor: Colors.transparent,
  );
}

Widget page3(BuildContext context){
  return OnboardingPage(
    backgroundImage: 'assets/images/onboarding_3.png',
    title: Text(context.locale.title_onboarding_3, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFF8FAFC)),),
    subTitle: Text(context.locale.subtitle_onboarding_3, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFFCBD5E1),), textAlign: TextAlign.center,),
    imageScale: 1,
    backgroundColor: Colors.transparent,
  );
}

Widget page4(BuildContext context){
  return OnboardingPage(
    backgroundImage: 'assets/images/onboarding_4.png',
    title: Text(context.locale.title_onboarding_4, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFF8FAFC)),),
    subTitle: Text(context.locale.subtitle_onboarding_4, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFFCBD5E1),), textAlign: TextAlign.center,),
    imageScale: 1,
    backgroundColor: Colors.transparent,
  );
}