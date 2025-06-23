// import 'dart:io';
// import 'package:ads_tracking_plugin/ad_config.dart';
// import 'package:ads_tracking_plugin/ads_controller.dart';
// import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
// import 'package:drumpad_flutter/core/utils/locator_support.dart';
// import 'package:drumpad_flutter/src/widgets/overlay_loading/overlay_loading.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:open_settings_plus/core/open_settings_plus.dart';
//
//
// String bannerAdUnitId = Platform.isAndroid ? "ca-app-pub-3940256099942544/6300978111" : "ca-app-pub-3940256099942544/2934735716";
// String interstitialAdUnitId = Platform.isAndroid ? "ca-app-pub-3940256099942544/1033173712" : "ca-app-pub-3940256099942544/4411468910";
// String nativeAdUnitId = Platform.isAndroid ? "ca-app-pub-3940256099942544/2247696110" : "ca-app-pub-3940256099942544/3986624511";
// String rewardedAdUnitId = Platform.isAndroid ? "ca-app-pub-3940256099942544/5224354917" : "ca-app-pub-3940256099942544/1712485313";
// String openAdUnitId = Platform.isAndroid ? "" : "ca-app-pub-3940256099942544/5575463023";
// String collapsibleBannerAdUnitId = Platform.isAndroid ? "" : "ca-app-pub-3940256099942544/8388050270";
//
// class AdUnitId {
//   static bool devMode = true;
//
//   static String inter_splash = devMode ? interstitialAdUnitId: "ca-app-pub-6691965685689933/8862284060";
//   static String inter_home = devMode ? interstitialAdUnitId: "ca-app-pub-6691965685689933/5531744842";
//   static String inter_result = devMode ? interstitialAdUnitId: "ca-app-pub-6691965685689933/5531744842";
//
//   static String native_language = devMode ? nativeAdUnitId: "ca-app-pub-6691965685689933/8211322033";
//   static String native_onboarding_1_1 = devMode ? nativeAdUnitId: "ca-app-pub-6691965685689933/6921764430";
//   static String native_onboarding_1_4 = devMode ? nativeAdUnitId: "ca-app-pub-6691965685689933/7549202394";
//
//   static String open_resume = devMode ? openAdUnitId: "ca-app-pub-6691965685689933/5608682768";
//
//   static String banner_collap_all = devMode ? collapsibleBannerAdUnitId: "ca-app-pub-6691965685689933/4295601099";
//
//   static String reward_choose_song = devMode ? rewardedAdUnitId: "ca-app-pub-6691965685689933/2982519428";
// }
//
// List<AdConfiguration> getAdConfigurations(bool isFirstOpenApp) {
//   bool preload = isFirstOpenApp;
//   return [
//     AdConfiguration(
//       adUnit: AdUnit(defaultId: AdUnitId.inter_splash),
//       loadType: LoadType.highestFloorAsync,
//       name: 'inter_splash',
//       format: AdFormat.interstitial,
//       loadTimeOut: 25,
//       preload: true,
//     ),
//     AdConfiguration(
//       adUnit: AdUnit(defaultId: AdUnitId.inter_home),
//       name: 'inter_home',
//       format: AdFormat.interstitial,
//     ),
//     AdConfiguration(
//       adUnit: AdUnit(defaultId: AdUnitId.inter_result),
//       name: 'inter_result',
//       format: AdFormat.interstitial,
//     ),
//     ///native
//     AdConfiguration(
//       adUnit: AdUnit(defaultId: AdUnitId.native_language),
//       name: 'native_language',
//       format: AdFormat.native,
//       nativeFactoryId: NativeFactoryId.layoutAdLarge,
//       nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaGradientStartColor: "#6141BE", ctaGradientEndColor: "#421AB5"),
//       preload: preload,
//     ),
//     AdConfiguration(
//       adUnit: AdUnit(defaultId: AdUnitId.native_onboarding_1_1),
//       name: 'native_onboarding_1_1',
//       format: AdFormat.native,
//       nativeFactoryId: NativeFactoryId.layoutAdLarge,
//       nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaGradientStartColor: "#6141BE", ctaGradientEndColor: "#421AB5"),
//       preload: preload,
//     ),
//     AdConfiguration(
//       adUnit: AdUnit(defaultId: AdUnitId.native_onboarding_1_4),
//       name: 'native_onboarding_1_4',
//       format: AdFormat.native,
//       nativeFactoryId: NativeFactoryId.layoutAdLarge,
//       nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaGradientStartColor: "#6141BE", ctaGradientEndColor: "#421AB5"),
//       preload: preload,
//     ),
//     ///banner
//     AdConfiguration(
//       adUnit: AdUnit(defaultId: AdUnitId.banner_collap_all),
//       name: 'banner_collap_all',
//       format: AdFormat.collapsibleBanner,
//       preload: true,
//       adRequest: const AdRequest(extras: {
//         "collapsible": "bottom",
//       }),
//     ),
//     ///reward
//     AdConfiguration(
//       adUnit: AdUnit(defaultId: AdUnitId.reward_choose_song),
//       name: 'reward_choose_song',
//       format: AdFormat.rewarded,
//     ),
//     ///resume
//     AdConfiguration(
//       adUnit: AdUnit(defaultId: AdUnitId.open_resume),
//       name: 'open_resume',
//       format: AdFormat.appOpen,
//     ),
//   ];
// }
//
// Future<void> showRewardAd({required BuildContext context, required String adId, required Function onUserEarnedReward, Function? onAdDismissedFullScreenContent}) async {
//   try {
//     AdController.shared.rewardedAd.showAd(
//         adId,
//         onRewardEarned: (_, __) async {
//           OverlayLoading.hide();
//           await onUserEarnedReward();
//         },
//         onFullScreenAdDismissed: (_) {
//           onAdDismissedFullScreenContent?.call();
//         },
//         onLoadingStateChanged: (isLoading, [error]) {
//           if (isLoading) {
//             OverlayLoading.show(context);
//           } else {
//             OverlayLoading.hide();
//             if (error != null) {
//               print(error);
//               showCupertinoDialog(
//                 context: context,
//                 barrierDismissible: true,
//                 builder: (context) {
//                   return CupertinoAlertDialog(
//                     title: Text(context.locale.lost_connection),
//                     content: Text(error.contains(
//                         "The Internet connection appears to be offline")
//                         ? context.locale.please_connect_internet_and_try_again
//                         : context.locale.something_went_wrong
//                     ),
//                     actions: [
//                       CupertinoDialogAction(
//                         onPressed: () {
//                           AdController.shared.setResumeAdState(true);
//                           OpenSettingsPlusIOS settings = const OpenSettingsPlusIOS();
//                           settings.wifi();
//                         },
//                         child: Text(context.locale.go_to_settings,
//                             style: const TextStyle(
//                                 color: Color(0xFF007AFF),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600
//                             )
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ).then((_) => {
//                 AdController.shared.setResumeAdState(false)
//               });
//             }
//           }
//         }
//     );
//   } catch (e) {
//     OverlayLoading.hide();
//     print("Ad failed to load: $e");
//   }
// }
