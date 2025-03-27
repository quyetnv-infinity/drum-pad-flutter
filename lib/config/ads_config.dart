import 'dart:io';
import 'package:ads_tracking_plugin/ad_config.dart';


String bannerAdUnitId = Platform.isAndroid ? "ca-app-pub-3940256099942544/6300978111" : "ca-app-pub-3940256099942544/2934735716";
String interstitialAdUnitId = Platform.isAndroid ? "ca-app-pub-3940256099942544/1033173712" : "ca-app-pub-3940256099942544/4411468910";
String nativeAdUnitId = Platform.isAndroid ? "ca-app-pub-3940256099942544/2247696110" : "ca-app-pub-3940256099942544/3986624511";
String rewardedAdUnitId = Platform.isAndroid ? "ca-app-pub-3940256099942544/5224354917" : "ca-app-pub-3940256099942544/1712485313";
String openAdUnitId = Platform.isAndroid ? "" : "ca-app-pub-3940256099942544/5575463023";
String collapsibleBannerAdUnitId = Platform.isAndroid ? "" : "ca-app-pub-3940256099942544/8388050270";

class AdUnitId {
  static bool devMode = true;

  static String inter_splash = devMode ? interstitialAdUnitId: "ca-app-pub-6691965685689933/7992888706";
  static String inter_trendy_video = devMode ? interstitialAdUnitId: "ca-app-pub-6691965685689933/9250130056";
  static String inter_home = devMode ? interstitialAdUnitId: "ca-app-pub-6691965685689933/7406803022";
  static String inter_fusion = devMode ? interstitialAdUnitId: "ca-app-pub-6691965685689933/2142868052";
  static String inter_result = devMode ? interstitialAdUnitId: "ca-app-pub-6691965685689933/9508284380";

  static String native_language = devMode ? nativeAdUnitId: "ca-app-pub-6691965685689933/3647521413";
  static String native_onboarding_1_1 = devMode ? nativeAdUnitId: "ca-app-pub-6691965685689933/5366725361";
  static String native_onboarding_1_4 = devMode ? nativeAdUnitId: "ca-app-pub-6691965685689933/3134447725";
  static String native_home = devMode ? nativeAdUnitId : "ca-app-pub-6691965685689933/5086657794";

  static String open_resume = devMode ? openAdUnitId: "ca-app-pub-6691965685689933/1821366055";
}

List<AdConfiguration> getAdConfigurations(bool isFirstOpenApp) {
  bool preload = isFirstOpenApp;
  return [
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.inter_splash),
      loadType: LoadType.highestFloorAsync,
      name: 'inter_splash',
      format: AdFormat.interstitial,
      loadTimeOut: 25,
      preload: true,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.inter_home),
      name: 'inter_home',
      format: AdFormat.interstitial,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.inter_trendy_video),
      name: 'inter_trendy_video',
      format: AdFormat.interstitial,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.inter_fusion),
      name: 'inter_fusion',
      format: AdFormat.interstitial,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.inter_result),
      name: 'inter_result',
      format: AdFormat.interstitial,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.native_language),
      name: 'native_language',
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdLarge,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaGradientStartColor: "#2F80ED", ctaGradientEndColor: "#56CCF2"),
      preload: preload,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.native_onboarding_1_1),
      name: 'native_onboarding_1_1',
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdLarge,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaGradientStartColor: "#2F80ED", ctaGradientEndColor: "#56CCF2"),
      preload: preload,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.native_onboarding_1_4),
      name: 'native_onboarding_1_4',
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdLarge,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaGradientStartColor: "#2F80ED", ctaGradientEndColor: "#56CCF2"),
      preload: preload,
    ),
    // AdConfiguration(
    //   adUnit: AdUnit(defaultId: AdUnitId.native_home),
    //   name: 'native_home',
    //   format: AdFormat.native,
    //   nativeFactoryId: NativeFactoryId.layoutCustom,
    //   nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF"),
    //   preload: true,
    //   disabled: !native_home_enabled
    // ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.open_resume),
      name: 'open_resume',
      format: AdFormat.appOpen,
    ),
  ];
}
