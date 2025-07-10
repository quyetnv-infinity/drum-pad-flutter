import 'dart:io';
import 'dart:ui';
import 'package:ads_tracking_plugin/ad_config.dart';
import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
import 'package:flutter/material.dart';

String bannerAdUnitId = Platform.isAndroid ? "ca-app-pub-3940256099942544/6300978111" : "ca-app-pub-3940256099942544/2934735716";
String interstitialAdUnitId = Platform.isAndroid ? "ca-app-pub-3940256099942544/1033173712" : "ca-app-pub-3940256099942544/4411468910";
String nativeAdUnitId = Platform.isAndroid ? "ca-app-pub-3940256099942544/2247696110" : "ca-app-pub-3940256099942544/3986624511";
String rewardedAdUnitId = Platform.isAndroid ? "ca-app-pub-3940256099942544/5224354917" : "ca-app-pub-3940256099942544/1712485313";
String openAdUnitId = Platform.isAndroid ? "/21775744923/example/app-open" : "ca-app-pub-3940256099942544/5575463023";
String collapsibleBannerAdUnitId =Platform.isAndroid ? 'ca-app-pub-3940256099942544/2014213617' : 'ca-app-pub-3940256099942544/8388050270';

class AdUnitId {
  static bool devMode = true;

  static String interSplash = devMode ? interstitialAdUnitId: "ca-app-pub-7208941695689653/4809744986";
  static String openResume = devMode ? openAdUnitId: "ca-app-pub-7208941695689653/7270039754";

  static String interHome = devMode ? interstitialAdUnitId: "ca-app-pub-7208941695689653/3330794743";

  static String nativeLanguage = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/6692273498";
  static String nativeLanguage2 = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/8413113926";
  static String nativeLanguageClick = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/4643876416";
  static String nativeLanguageClick2 = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/7100032258";
  static String nativeLanguageCountry = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/8557418302";
  static String nativeLanguageCountry_2 = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/4618173292";

  static String nativeOnboarding = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/3305091628";
  static String nativeOnboarding2 = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/2654354937";
  static String nativeOnboardingPage3 = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/9678928281";
  static String nativeOnboardingPage32 = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/7052764947";

  static String nativePermission = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/6498231176";
  static String nativeResearch = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/1800438261";
  static String nativePopupPlayDone = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/9487356590";
  static String nativePopupPause = devMode ? nativeAdUnitId:"ca-app-pub-7208941695689653/2753028489";

  static String bannerCollapsibleHome = devMode ? collapsibleBannerAdUnitId:"ca-app-pub-7208941695689653/5739683277";

  static String bannerCampaign = devMode ? bannerAdUnitId:"ca-app-pub-7208941695689653/9028191591";
}

class AdName {
  static String interSplash = "inter_splash";
  static String openResume = "open_resume";

  static String interHome = "inter_home";

  static String nativeLanguage = "native_language";
  static String nativeLanguage2 = "native_language_2";
  static String nativeLanguageClick = "native_language_click";
  static String nativeLanguageClick2 = "native_language_click_2";
  static String nativeLanguageCountry = "native_language_country";
  static String nativeLanguageCountry_2 = "native_language_country_2";

  static String nativeOnboarding = "native_onboarding";
  static String nativeOnboarding2 = "native_onboarding_2";
  static String nativeOnboardingPage3 = "native_onboarding_page3";
  static String nativeOnboardingPage32 = "native_onboarding_page3_2";

  static String nativePermission = "native_permission";
  static String nativeSearch = "native_search";
  static String nativePopupPlayDone = "native_popup_playdone";
  static String nativePopupPause = "native_popup_pause";

  static String bannerCollapsibleHome = "banner_home";

  static String bannerCampaign = "banner_campaign";
}

List<AdConfiguration> getAdConfigurations(bool isFirstOpenApp) {
  double ctaCornerRadius = 16;
  String ctaColor = "#FF9800";
  bool preload = isFirstOpenApp;
  double ctaHeight = RemoteConfig.getCtaNativeHeight();
  print("Preload ads: $preload");
  return [
    /// Interstitial Ads
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.interSplash),
      loadType: LoadType.highestFloorAsync,
      name: AdName.interSplash,
      format: AdFormat.interstitial,
      loadTimeOut: 25,
      preload: true,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.interHome),
      name: AdName.interHome,
      format: AdFormat.interstitial,
    ),
    
    /// Native Ads - Language
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeLanguage),
      name: AdName.nativeLanguage,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdTextFirst,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeLanguage2),
      name: AdName.nativeLanguage2,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdTextFirst,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF",ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeLanguageClick),
      name: AdName.nativeLanguageClick,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdTextFirst,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeLanguageClick2),
      name: AdName.nativeLanguageClick2,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdTextFirst,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeLanguageCountry),
      name: AdName.nativeLanguageCountry,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdTextFirst,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeLanguageCountry_2),
      name: AdName.nativeLanguageCountry_2,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdTextFirst,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF",ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    
    /// Native Ads - Onboarding
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeOnboarding),
      name: AdName.nativeOnboarding,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdTextFirst,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeOnboarding2),
      name: AdName.nativeOnboarding2,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdTextFirst,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeOnboardingPage3),
      name: AdName.nativeOnboardingPage3,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdTextFirst,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeOnboardingPage32),
      name: AdName.nativeOnboardingPage32,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdTextFirst,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    
    /// Native Ads - Others
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativePermission),
      name: AdName.nativePermission,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdTextFirst,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativeResearch),
      name: AdName.nativeSearch,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutMediumCtaFullBottom,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativePopupPlayDone),
      name: AdName.nativePopupPlayDone,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdSmall,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.nativePopupPause),
      name: AdName.nativePopupPause,
      format: AdFormat.native,
      nativeFactoryId: NativeFactoryId.layoutAdSmall,
      nativeCustomOptions: NativeCustomOptions(textColor: "#FFFFFF", ctaColor: ctaColor, ctaCornerRadius: ctaCornerRadius, ctaHeight: ctaHeight),
      preload: preload,
    ),
    
    /// Banner Ads
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.bannerCollapsibleHome),
      name: AdName.bannerCollapsibleHome,
      format: AdFormat.collapsibleBanner,
      preload: true,
      adRequest: const AdRequest(extras: {
        "collapsible": "bottom",
      }),
    ),
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.bannerCampaign),
      name: AdName.bannerCampaign,
      format: AdFormat.collapsibleBanner,
      preload: true,
    ),
    
    /// App Open Ad
    AdConfiguration(
      adUnit: AdUnit(defaultId: AdUnitId.openResume),
      name: AdName.openResume,
      format: AdFormat.appOpen,
    ),
  ];
}
