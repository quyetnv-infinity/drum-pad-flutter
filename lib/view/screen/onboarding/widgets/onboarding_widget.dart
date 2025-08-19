import 'package:ads_tracking_plugin/native_ad/native_ad_widget.dart';
import 'package:and_drum_pad_flutter/config/ads_config.dart';
import 'package:and_drum_pad_flutter/core/res/dimen/spacing.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view_model/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomPage extends StatelessWidget {
  final String backgroundAsset;
  final String title;
  final String subtitle;
  final EdgeInsets? imagePadding;
  final int dataLength;
  final int currentPage;
  final Color? color;
  final Function() onTapNext;
  final Widget? adWidget;

  const CustomPage({
    super.key,
    required this.backgroundAsset,
    required this.title,
    required this.subtitle,
    this.imagePadding,
    required this.dataLength,
    required this.currentPage,
    required this.color,
    required this.onTapNext,
    this.adWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Image.asset(
                    'assets/images/bg_onboarding.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: imagePadding ?? EdgeInsets.zero,
                  child: Image.asset(
                    width: MediaQuery.of(context).size.width,
                    backgroundAsset,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
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
                // Custom Page Indicator thay cho SmoothPageIndicator
                Row(
                  children: List.generate(
                    dataLength,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      height: 8.0,
                      width: currentPage == index ? 24.0 : 8.0,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onTapNext,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(44.0),
                    ),
                    child: Text(
                      currentPage == 3
                          ? context.locale.start
                          : context.locale.next,
                      style: const TextStyle(
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
          ResSpacing.h24,
          if (adWidget != null) adWidget!,
        ],
      ),
    );
  }
}

// Update các page functions để không cần PageController nữa
Widget page1(BuildContext context,
    {int dataLength = 4,
      int currentPage = 0,
      required Function() onTapNext}) {
  return CustomPage(
    backgroundAsset: 'assets/images/onboarding_1.png',
    title: context.locale.title_onboarding_1,
    subtitle: context.locale.subtitle_onboarding_1,
    currentPage: currentPage,
    dataLength: dataLength,
    onTapNext: onTapNext,
    color: Colors.red,
    adWidget: Consumer<AppStateProvider>(builder: (context, appStateProvider, _) {
      return NativeAdWidget(
        key: ValueKey(appStateProvider.isFirstOpenApp
            ? AdName.nativeOnboarding
            : AdName.nativeOnboarding2),
        margin: const EdgeInsets.only(top: 10),
        adName: appStateProvider.isFirstOpenApp
            ? AdName.nativeOnboarding
            : AdName.nativeOnboarding2,
        disabled: !appStateProvider.shouldShowAds,
        onAdLoaded: (value) {},
        height: 50,
        decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.2),
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(7)),
            border: Border.all(width: 1, color: const Color(0xFFD3D3D3))),
      );
    }),
  );
}

Widget page2(BuildContext context,
    {int dataLength = 4,
      int currentPage = 0,
      required Function() onTapNext}) {
  return CustomPage(
      backgroundAsset: 'assets/images/onboarding_2.png',
      title: context.locale.title_onboarding_2,
      subtitle: context.locale.subtitle_onboarding_2,
      currentPage: currentPage,
      dataLength: dataLength,
      onTapNext: onTapNext,
      color: Colors.blue);
}

Widget page3(BuildContext context,
    {int dataLength = 4,
      int currentPage = 0,
      required Function() onTapNext}) {
  return CustomPage(
      backgroundAsset: 'assets/images/onboarding_3.png',
      title: context.locale.title_onboarding_3,
      subtitle: context.locale.subtitle_onboarding_3,
      currentPage: currentPage,
      dataLength: dataLength,
      onTapNext: onTapNext,
      color: Colors.white);
}

Widget page4(BuildContext context,
    {int dataLength = 4,
      int currentPage = 0,
      required Function() onTapNext}) {
  return CustomPage(
    backgroundAsset: 'assets/images/onboarding_4.png',
    title: context.locale.title_onboarding_4,
    subtitle: context.locale.subtitle_onboarding_4,
    currentPage: currentPage,
    dataLength: dataLength,
    onTapNext: onTapNext,
    color: Colors.black,
    adWidget: Consumer<AppStateProvider>(builder: (context, appStateProvider, _) {
      return NativeAdWidget(
        margin: const EdgeInsets.only(top: 10),
        key: ValueKey(appStateProvider.isFirstOpenApp
            ? AdName.nativeOnboardingPage3
            : AdName.nativeOnboardingPage32),
        adName: appStateProvider.isFirstOpenApp
            ? AdName.nativeOnboardingPage3
            : AdName.nativeOnboardingPage32,
        disabled: !appStateProvider.shouldShowAds,
        onAdLoaded: (value) {},
        height: 50,
        decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.2),
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(7)),
            border: Border.all(width: 1, color: const Color(0xFFD3D3D3))),
      );
    }),
  );
}