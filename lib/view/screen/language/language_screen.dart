import 'dart:io';

import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:ads_tracking_plugin/native_ad/native_ad_widget.dart';
import 'package:ads_tracking_plugin/tracking/services/screen_logger.dart';
import 'package:ads_tracking_plugin/tracking/services/screen_time_tracker.dart';
import 'package:and_drum_pad_flutter/config/ads_config.dart';
import 'package:and_drum_pad_flutter/core/enum/language_enum.dart';
import 'package:and_drum_pad_flutter/core/extension/language_extension.dart';
import 'package:and_drum_pad_flutter/core/res/dimen/spacing.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/screen/onboarding/onboarding_screen.dart';
import 'package:and_drum_pad_flutter/view_model/app_state_provider.dart';
import 'package:and_drum_pad_flutter/view_model/locale_view_model.dart';
import 'package:base_ui_flutter_v1/base_ui_flutter_v1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  final bool fromSetting;

  const LanguageScreen({super.key, required this.fromSetting});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> with WidgetsBindingObserver, ScreenLogger<LanguageScreen>, ScreenTimeLogger<LanguageScreen>, AutomaticKeepAliveClientMixin<LanguageScreen> {
  bool _showDoneButton = false;
  bool _isSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.fromSetting) {
      AdController.shared.setResumeAdState(true);
      preloadAdsOnboarding();
    } else {
      AdController.shared.setResumeAdState(false);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocateViewModel>().initSelectedLanguage();
    });
  }

  void preloadAdsOnboarding() {
    final isFirstOpenApp = Provider.of<AppStateProvider>(context, listen: false).isFirstOpenApp;

    String onboardingAd1 = isFirstOpenApp ? AdName.nativeOnboarding : AdName.nativeOnboarding2;
    String onboardingAd2 = isFirstOpenApp ? AdName.nativeOnboardingPage3 : AdName.nativeOnboardingPage32;

    Future.wait([
      AdController.shared.preload(name: onboardingAd1),
      AdController.shared.preload(name: onboardingAd2),
    ]);
  }

  String getAdName() {
    final isFirstOpenApp = Provider.of<AppStateProvider>(context, listen: false).isFirstOpenApp;

    if(_isSelected) {
      return isFirstOpenApp ? AdName.nativeLanguageClick : AdName.nativeLanguageClick2;
    }

    return isFirstOpenApp ? AdName.nativeLanguage : AdName.nativeLanguage2;
  }

  void _onLanguageSelected(LanguageEnum value, LocateViewModel provider) {
    provider.selectLanguage(value);

    if(!_isSelected) {
      setState(() {
        _isSelected = true;
      });
    }

    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showDoneButton = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: widget.fromSetting ? true : false,
      onPopInvokedWithResult: (didPop, result) {
        if (!widget.fromSetting) {
          exit(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Language',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          centerTitle: false,
          actions: [
            if (_showDoneButton || widget.fromSetting)
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  context.read<LocateViewModel>().saveLanguage();
                  if (widget.fromSetting) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen(),),);
                  }
                },
                child: Row(
                  children: [
                    SvgPicture.asset(ResIcon.icCheck2, width: 18, height: 18),
                  ],
                ),
              ),
            ResSpacing.w16,
          ],
        ),
        body: Consumer<LocateViewModel>(builder: (context, provider, child) {
          return LanguageWidget<LanguageEnum>(
            languages: LanguageEnum.en.getPrioritizedLanguages,
            selectedLanguage: widget.fromSetting ? provider.selectedLanguage ?? LanguageEnum.en  : provider.selectedLanguage,
            onLanguageChanged: (value) => _onLanguageSelected(value, provider),
            itemTextStyleBuilder: (item, isSelected) => TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            spacingItem: 10,
            displayLanguageNameBuilder: (item) => item.displayName,
            itemDecorationBuilder: (item, isSelected) {
              return BoxDecoration(
                color: Color(0xFF343437),
                borderRadius: BorderRadius.circular(100),
                border:  Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: isSelected ? 0.6: 0,
                ),
              );
            },
            leadingBuilder: (context, item) {
              return Radio<LanguageEnum>(
                activeColor: Colors.white,
                value: item,
                groupValue: widget.fromSetting ? provider.selectedLanguage ?? LanguageEnum.en : provider.selectedLanguage,
                onChanged: (value) => _onLanguageSelected(value!, provider),
              );
            },
          );
        },),
        bottomNavigationBar: widget.fromSetting ? SizedBox.shrink() : Consumer<AppStateProvider>(builder: (context, provider, child) {
          return NativeAdWidget(
            key: ValueKey(getAdName()),
            adName: getAdName(),
            disabled: !provider.shouldShowAds,
            onAdLoaded: (value) {
              // print("AdLoader - load native ads ${getAdName()}: $value");
              if(value && (getAdName() == AdName.nativeLanguage || getAdName() == AdName.nativeLanguage2)) {
                Future.delayed(Duration(milliseconds: 1000), () {
                  if (mounted) {
                    setState(() {

                    });
                  }
                });
              }
            },
            decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                border: Border.all(width: 1, color: Color(0x80D3D3D3))
            ),
          );
        },),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

