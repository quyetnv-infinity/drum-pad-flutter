import 'dart:io';

import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:ads_tracking_plugin/native_ad/native_ad_widget.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  final bool fromSetting;

  const LanguageScreen({super.key, required this.fromSetting});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

enum AdState {
  initial, // nativeLanguage || nativeLanguage2
  englishClick, // nativeLanguageCountry || nativeLanguageCountry2
  otherClick // nativeLanguageClick || nativeLanguageClick2
}

class _LanguageScreenState extends State<LanguageScreen>
    with WidgetsBindingObserver {
  AdState _currentAdState = AdState.initial;
  bool _isContryAdsLoaded = false;
  bool _isClickAdsLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocateViewModel>().initSelectedLanguage();
      Future.delayed(
        Duration(milliseconds: 500),
        () {
          setState(() {});
        },
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (widget.fromSetting) return;
    if (state == AppLifecycleState.paused) {
      AdController.shared.setResumeAdState(true);
    }
    if (state == AppLifecycleState.resumed) {
      AdController.shared.setResumeAdState(false);
    }
  }

  String _getAdName(bool isFirstOpenApp) {
    switch (_currentAdState) {
      case AdState.initial:
        return isFirstOpenApp ? AdName.nativeLanguage : AdName.nativeLanguage2;
      case AdState.englishClick:
        return isFirstOpenApp
            ? AdName.nativeLanguageCountry
            : AdName.nativeLanguageCountry_2;
      case AdState.otherClick:
        return isFirstOpenApp
            ? AdName.nativeLanguageClick
            : AdName.nativeLanguageClick2;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.fromSetting ? true : false,
      onPopInvokedWithResult: (didPop, result) {
        if (!widget.fromSetting) {
          exit(0);
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFF161616),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            context.locale.language,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          centerTitle: false,
          actions: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  context.read<LocateViewModel>().saveLanguage();
                  if (widget.fromSetting) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen(),));
                  }
                },
                child: Row(
                  children: [
                    SvgPicture.asset(ResIcon.icCheck2),
                    ResSpacing.w8,
                    Text(
                      context.locale.done.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ResSpacing.w16,
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Consumer<LocateViewModel>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11.0),
                child: LanguageWidget<LanguageEnum>(
                  languages: LanguageEnum.en.getPrioritizedLanguages,
                  selectedLanguage:widget.fromSetting ? provider.selectedLanguage ?? LanguageEnum.en  : provider.selectedLanguage,
                  onLanguageChanged: (value) {
                    if(!_isClickAdsLoaded){
                      setState(() {
                        _currentAdState = AdState.otherClick;
                        _isClickAdsLoaded = true;
                      });
                    }
                    provider.selectLanguage(value);
                  },
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
                    print("Selected language: ${item.displayName}");
                    return Radio<LanguageEnum>(
                      activeColor: Colors.white,
                      value: item,
                      groupValue: widget.fromSetting ? provider.selectedLanguage ?? LanguageEnum.en : provider.selectedLanguage,
                      onChanged: (value) {
                        if (value == null) return;
                        if(!_isClickAdsLoaded){
                          setState(() {
                            _currentAdState = AdState.otherClick;
                            _isClickAdsLoaded = true;
                          });
                        }
                        provider.selectLanguage(value);
                      },
                    );
                  },

                ),
              );
            },
          ),
        ),
        bottomNavigationBar: widget.fromSetting ? SizedBox.shrink() : Consumer<AppStateProvider>(builder: (context, value, child) {
          return NativeAdWidget(
            key: ValueKey(_currentAdState),
            adName: _getAdName(value.isFirstOpenApp),
            disabled: !value.shouldShowAds,
            onAdLoaded: (value) {
              print("Native ad loaded: $value");
            },
            decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                border: Border.all(width: 1, color: Color(0xFFD3D3D3))
            ),
          );
        },),
      ),
    );
  }
}
