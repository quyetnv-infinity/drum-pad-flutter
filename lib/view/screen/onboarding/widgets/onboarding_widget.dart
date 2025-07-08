import 'package:ads_tracking_plugin/native_ad/native_ad_widget.dart';
import 'package:and_drum_pad_flutter/config/ads_config.dart';
import 'package:and_drum_pad_flutter/core/res/dimen/spacing.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view_model/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget customPage(
    {required BuildContext context,
    required String backgroundAsset,
    required String title,
    required String subtitle,
    EdgeInsets? imagePadding,
    required PageController controller,
    int dataLength = 4,
    int currentPage = 0,
    required Function() onTapNext}) {
  return Expanded(
    child: Column(
      children: [
        Expanded(
          child: Padding(
            padding: imagePadding ?? EdgeInsets.zero,
            child: Image.asset(
              width: MediaQuery.of(context).size.width,
              backgroundAsset,
              fit: BoxFit.cover,
            ),
          ),
        ),
        ResSpacing.h24,
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFCCCDD0),
              fontSize: 14,
            ),
          ),
        ),
        ResSpacing.h12,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              SmoothPageIndicator(
                controller: controller,
                count: dataLength,
                effect: WormEffect(
                  dotColor: Colors.white.withValues(alpha: 0.2),
                  activeDotColor: Colors.white,
                  dotHeight: 8.0,
                  dotWidth: 8.0,
                ),
              ),
              const Spacer(),
              InkWell(
               onTap: onTapNext,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(44.0),
                  ),
                  child: Text(
                    currentPage == 3 ? context.locale.start : context.locale.next,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget page1(BuildContext context,
    {required PageController controller,
    int dataLength = 4,
    int currentPage = 0,
    required Function() onTapNext}) {
  return Column(
    children: [
      customPage(
        context: context,
        backgroundAsset: 'assets/images/onboarding_1.png',
        title: context.locale.title_onboarding_1,
        subtitle: context.locale.subtitle_onboarding_1,
        controller: controller,
        currentPage: currentPage,
        dataLength: dataLength,
        onTapNext: onTapNext,
      ),
      Consumer<AppStateProvider>(
          builder: (context, appStateProvider, _) {
            return NativeAdWidget(
              key: ValueKey(appStateProvider.isFirstOpenApp ? AdName.nativeOnboarding : AdName.nativeOnboarding2),
              margin: EdgeInsets.only(top: 10),
              adName: appStateProvider.isFirstOpenApp ? AdName.nativeOnboarding : AdName.nativeOnboarding2,
              disabled: !appStateProvider.shouldShowAds,
              onAdLoaded: (value) {
                print("Native ad loaded: $value");
              },
              decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                  border: Border.all(width: 1, color: Color(0xFFD3D3D3))
              ),
            );
          }
      ),
    ],
  );
}

Widget page2(BuildContext context,
    {required PageController controller,
    int dataLength = 4,
    int currentPage = 0,required Function() onTapNext}) {
  return Column(
    children: [
      customPage(
        context: context,
        backgroundAsset: 'assets/images/onboarding_2.png',
        title: context.locale.title_onboarding_2,
        subtitle: context.locale.subtitle_onboarding_2,
        controller: controller,
        currentPage: currentPage,
        dataLength: dataLength,
        onTapNext: onTapNext,
      ),
      SizedBox(
        height: kBottomNavigationBarHeight,
      ),
    ],
  );
}

Widget page3(BuildContext context,
    {required PageController controller,
    int dataLength = 4,
    int currentPage = 0,required Function() onTapNext}) {
  return Column(
    children: [
      customPage(
        context: context,
        backgroundAsset: 'assets/images/onboarding_3.png',
        title: context.locale.title_onboarding_3,
        subtitle: context.locale.subtitle_onboarding_3,
        controller: controller,
        currentPage: currentPage,
        dataLength: dataLength,
        onTapNext: onTapNext,
      ),
      SizedBox(
        height: kBottomNavigationBarHeight,
      ),
    ],
  );
}

Widget page4(BuildContext context,
    {required PageController controller,
    int dataLength = 4,
    int currentPage = 0,required Function() onTapNext}) {
  return Column(
    children: [
      customPage(
        context: context,
        backgroundAsset: 'assets/images/onboarding_4.png',
        title: context.locale.title_onboarding_4,
        subtitle: context.locale.subtitle_onboarding_4,
        controller: controller,
        currentPage: currentPage,
        dataLength: dataLength,
        onTapNext: onTapNext,
      ),
      Consumer<AppStateProvider>(
          builder: (context, appStateProvider, _) {
            return NativeAdWidget(
              margin: EdgeInsets.only(top: 10),
              key: ValueKey(appStateProvider.isFirstOpenApp ? AdName.nativeOnboardingPage3 : AdName.nativeOnboardingPage32),
              adName: appStateProvider.isFirstOpenApp ? AdName.nativeOnboardingPage3 : AdName.nativeOnboardingPage32,
              disabled: !appStateProvider.shouldShowAds,
              onAdLoaded: (value) {
                print("Native ad loaded: $value");
              },
              decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                  border: Border.all(width: 1, color: Color(0xFFD3D3D3))
              ),
            );
          }
      )
    ],
  );
}
